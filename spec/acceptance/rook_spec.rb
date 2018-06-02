require 'spec_helper_acceptance'

describe 'the rook module' do

  describe 'kubernetes class' do
    context 'it should install the module' do
      let(:pp) {"
      class {'kubernetes':
        controller => true,
        schedule_on_controller => true,
      }
      "}
      it 'should run' do
        apply_manifest(pp, :catch_failures => true)
      end
      it 'should install kubectl' do
        shell('kubectl', :acceptable_exit_codes => [0])
      end
      it 'should install kube-dns' do
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf; kubectl get deploy --namespace kube-system kube-dns', :acceptable_exit_codes => [0])
        sleep(60)
      end
    end
  end

  describe 'rook class' do
    context 'it should install the module' do
      let(:pp) {"
      include rook
      "}
      it 'should run' do
        apply_manifest(pp, :catch_failures => true)
      end

      if fact('osfamily') == 'Debian'
        [ 'ceph-common',
          'ceph-fs-common'
        ].each do | package_name |
          it 'should contain packages' do
            expect(package(package_name)).to be_installed
          end
        end
      end

      if fact('osfamily') == 'RedHat'
        [ 'ceph-common',
          'ceph-deploy'
        ].each do | package_name |
          it 'should contain packages' do
            expect(package(package_name)).to be_installed
          end
        end
      end

      it 'should create rook namespace' do
        shell('sleep 120')
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl get namespaces | grep rook', :acceptable_exit_codes => [0])
      end

      it 'should create rook operator ' do
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook-system get pod | grep rook-operator', :acceptable_exit_codes => [0]) do |r|
            expect(r.stdout).to match(/Running/)
        end
      end

      it 'should create rook agent ' do
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook-system get pod | grep rook-agent', :acceptable_exit_codes => [0]) do |r|
            expect(r.stdout).to match(/Running/)
        end
      end

      it 'should create rook cluster and verify rook-api' do
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook get pod | grep rook-api', :acceptable_exit_codes => [0]) do |r|
            expect(r.stdout).to match(/Running/)
        end
      end
      it 'should create rook cluster and verify rook-ceph-mgr0' do
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook get pod | grep rook-ceph-mgr0', :acceptable_exit_codes => [0]) do |r|
            expect(r.stdout).to match(/Running/)
        end
      end
      it 'should create rook cluster and verify rook-ceph-mon0' do
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook get pod | grep rook-ceph-mon0', :acceptable_exit_codes => [0]) do |r|
            expect(r.stdout).to match(/Running/)
        end
      end
      it 'should create rook cluster and verify rook-ceph-mon1' do
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook get pod | grep rook-ceph-mon1', :acceptable_exit_codes => [0]) do |r|
            expect(r.stdout).to match(/Running/)
        end
      end
      it 'should create rook cluster and verify rook-ceph-mon2' do
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook get pod | grep rook-ceph-mon2', :acceptable_exit_codes => [0]) do |r|
            expect(r.stdout).to match(/Running/)
        end
      end
      it 'should create rook cluster and verify rook-ceph-osd' do
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook get pod | grep rook-ceph-osd', :acceptable_exit_codes => [0]) do |r|
            expect(r.stdout).to match(/Running/)
        end
      end
      it 'should create storage class' do
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl get storageclass | grep rook-block', :acceptable_exit_codes => [0])
      end
    end
  end
end
