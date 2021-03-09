# frozen_string_literal: true
require 'puppet_litmus'
require 'tempfile'
require 'pry'

include PuppetLitmus

def create_remote_file(name, full_name, file_content)
  Tempfile.open name do |tempfile|
            File.open(tempfile.path, 'w') {|file| file.puts file_content }
            bolt_upload_file(tempfile.path, full_name)
  end
end

def inventory_hash
  @inventory_hash ||= inventory_hash_from_inventory_file
end

def target_roles(roles)
  # rubocop:disable Style/MultilineBlockChain
  inventory_hash['groups'].map { |group|
    group['targets'].map { |node|
      { name: node['uri'], role: node['vars']['role'] } if roles.include? node['vars']['role']
    }.reject { |val| val.nil? }
  }.flatten
  # rubocop:enable Style/MultilineBlockChain
end

def fetch_platform_by_node(uri)
  # rubocop:disable Style/MultilineBlockChain
  inventory_hash['groups'].map { |group|
    group['targets'].map { |node|
      if node['uri'] == uri
        return node['facts']['platform']
      else
        return nil
      end
    }
  }
  # rubocop:enable Style/MultilineBlockChain
end

def fetch_ip_hostname_by_role(role)
   #Fetch hostname and  ip adress for each node
   ipaddr = target_roles(role)[0][:name]
   platform = fetch_platform_by_node(ipaddr)
   ENV['TARGET_HOST'] = target_roles(role)[0][:name]
   hostname = run_shell('hostname').stdout.strip
   if os[:family] == 'redhat'
     int_ipaddr = run_shell("ip route get 8.8.8.8 | awk '{print $7; exit}'").stdout.strip
   else
     int_ipaddr = run_shell("ip route get 8.8.8.8 | awk '{print $NF; exit}'").stdout.strip
   end
   vmos = os[:family]

   puts "Running acceptance test on #{vmhostname} with address #{vmipaddr} and OS #{vmos}"

   run_shell('puppet module install puppetlabs-kubernetes')
   run_shell('puppet module install puppetlabs-helm')
   run_shell('puppet module install puppetlabs-stdlib')
   run_shell('puppet module install stahnma-epel')

   run_shell('puppet module install puppet-archive')

   run_shell('puppet module install puppetlabs-docker')

hosts_file = <<-EOS
127.0.0.1 localhost #{vmhostname} kubernetes kube-control-plane
#{vmipaddr} #{vmhostname}
#{vmipaddr} kubernetes
#{vmipaddr} kube-master
      EOS

      nginx = <<-EOS
apiVersion: v1
kind: Namespace
metadata:
  name: nginx
---
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: my-nginx
  namespace: nginx
spec:
  template:
    metadata:
      name: my-nginx
      namespace: nginx
    spec:
      template:
        metadata:
          labels:
            run: my-nginx
        spec:
          containers:
          - name: my-nginx
            image: nginx:1.12-alpine
            ports:
            - containerPort: 80
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: my-nginx
      namespace: nginx
      labels:
        run: my-nginx
    spec:
      clusterIP: 10.96.188.5
      ports:
      - port: 80
        protocol: TCP
      selector:
        run: my-nginx
    EOS

      hiera = <<-EOS
version: 5
defaults:
  datadir: /etc/puppetlabs/code/environments/production/hieradata
  data_hash: yaml_data
hierarchy:
  - name: "Per-node data (yaml version)"
    path: "nodes/%{trusted.certname}.yaml" # Add file extension.
    # Omitting datadir and data_hash to use defaults.
  - name: "Other YAML hierarchy levels"
    paths: # Can specify an array of paths instead of one.
      - "location/%{facts.whereami}/%{facts.group}.yaml"
      - "groups/%{facts.group}.yaml"
      - "os/%{facts.os.family}.yaml"
      - "#{family.capitalize}.yaml"
      - "#{hostname1}.yaml"
      - "Redhat.yaml"
      - "common.yaml"
EOS
      k8repo = <<-EOS
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOS
  pp = <<-PUPPETCODE
    # needed by tests
    package { 'curl':
      ensure   => 'latest',
    }
    package { 'git':
      ensure   => 'latest',
    }
  PUPPETCODE
  apply_manifest(pp)
  if family =~ /debian|ubuntu-1604-lts/
    runtime = 'cri_containerd'
    cni = 'weave'
    run_shell('apt-get update && apt-get install -y apt-transport-https')
    run_shell('curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -')
    run_shell('echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list')
    run_shell('apt-get update')
    run_shell('apt-get install -y kubectl')
    run_shell('sudo apt install docker-ce=18.06.0~ce~3-0~ubuntu  docker-ce-cli=18.06.0~ce~3-0~ubuntu -y')
    run_shell('sudo apt install docker.io -y')
    run_shell('systemctl start docker.service')
    run_shell('systemctl enable docker.service')
    if family =~ /ubuntu-1604-lts/
      run_shell('sudo ufw disable')
    else
      # Workaround for debian as the strech repositories do not have updated kubernetes packages
      run_shell('echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kube-xenial.list')
      run_shell('/sbin/iptables -F')
    end
  end
  if family =~ /redhat|centos/
    runtime = 'docker'
    cni = 'flannel'
    ['controller', 'worker1', 'worker2'].each { |node|
      ENV['TARGET_HOST'] = target_roles(node)[0][:name]
      run_shell('setenforce 0 || true')
      run_shell('swapoff -a')
      run_shell('systemctl stop firewalld && systemctl disable firewalld')
      run_shell('yum install -y yum-utils device-mapper-persistent-data lvm2')
      run_shell('yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo')
      run_shell('yum update -y')
      run_shell('yum install -y docker-ce-cli-18.09.0-3.el7.x86_64')
      run_shell('yum install -y docker-ce-18.09.5-3.el7.x86_64')
      run_shell("usermod -aG docker $(whoami)")
      run_shell('systemctl start docker.service')
      run_shell('systemctl enable docker.service')
      create_remote_file("k8repo","/etc/yum.repos.d/kubernetes.repo", k8repo)
      run_shell('yum install -y kubectl')
    }
  end

  ENV['TARGET_HOST'] = target_roles('controller')[0][:name]
  run_shell('docker build -t kubetool:latest /etc/puppetlabs/code/environments/production/modules/kubernetes/tooling')
  run_shell("docker run --rm -v $(pwd)/hieradata:/mnt -e OS=#{family} -e VERSION=1.16.6 -e CONTAINER_RUNTIME=#{runtime} -e CNI_PROVIDER=#{cni} -e ETCD_INITIAL_CLUSTER=#{hostname1}:#{int_ipaddr1} -e ETCD_IP=#{int_ipaddr1} -e ETCD_PEERS=[#{int_ipaddr1},#{int_ipaddr2},#{int_ipaddr3}] -e KUBE_API_ADVERTISE_ADDRESS=#{int_ipaddr1} -e INSTALL_DASHBOARD=true kubetool:latest")
  create_remote_file("nginx","/tmp/nginx.yml", nginx)
  create_remote_file("hiera","/etc/puppetlabs/puppet/hiera.yaml", hiera)
  run_shell('chmod 644 /etc/puppetlabs/puppet/hiera.yaml')
  create_remote_file("hiera_prod","/etc/puppetlabs/code/environments/production/hiera.yaml", hiera)
  run_shell('chmod 644 /etc/puppetlabs/code/environments/production/hiera.yaml')
  run_shell('mkdir -p /etc/puppetlabs/code/environments/production/hieradata')
  run_shell("cp $HOME/hieradata/*.yaml /etc/puppetlabs/code/environments/production/hieradata/")

  run_shell("sed -i /cni_network_provider/d /etc/puppetlabs/code/environments/production/hieradata/#{family.capitalize}.yaml")

  if family =~ /debian|ubuntu-1604-lts/
    run_shell("echo 'kubernetes::cni_network_provider: https://cloud.weave.works/k8s/net?k8s-version=1.16.6' >> /etc/puppetlabs/code/environments/production/hieradata/#{family.capitalize}.yaml")
  end

  if family =~ /redhat|centos/
    run_shell("echo 'kubernetes::cni_network_provider: https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml' >> /etc/puppetlabs/code/environments/production/hieradata/#{family.capitalize}.yaml")
  end

  run_shell("echo 'kubernetes::schedule_on_controller: true'  >> /etc/puppetlabs/code/environments/production/hieradata/#{family.capitalize}.yaml")
  run_shell("echo 'kubernetes::taint_master: false' >> /etc/puppetlabs/code/environments/production/hieradata/#{family.capitalize}.yaml")
  run_shell("echo 'kubernetes::manage_docker: false' >> /etc/puppetlabs/code/environments/production/hieradata/#{family.capitalize}.yaml")
  run_shell("export KUBECONFIG=\'/etc/kubernetes/admin.conf\'")
  execute_agent('controller')
  execute_agent('worker1')
  puppet_cert_sign
end
end
