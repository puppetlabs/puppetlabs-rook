require 'spec_helper_acceptance'

describe 'the rook module' do

  describe 'kubernetes class' do
    context 'it should install the module and run' do

      pp = <<-MANIFEST
      if $::osfamily == 'RedHat'{
        class {'kubernetes':
                container_runtime => 'docker',
                manage_docker => false,
                controller => true,
                schedule_on_controller => true,
                environment  => ['HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf'],
                ignore_preflight_errors => ['NumCPU'],
                cgroup_driver => 'cgroupfs'
              }
        }
      if $::osfamily == 'Debian'{
        class {'kubernetes':
                controller => true,
                schedule_on_controller => true,
                environment  => ['HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf'],
                ignore_preflight_errors => ['NumCPU'],
              }
        }
  MANIFEST
      it 'should run' do
        apply_manifest(pp)
      end
      it 'should install kubectl' do
        run_shell('kubectl')
      end
      it 'should install kube-dns' do
        run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf; kubectl get deploy --namespace kube-system coredns')
        sleep(60)
      end
    end
  end
#   describe 'rook class' do
#     context 'it should install the module' do
#       let(:pp) {"
#       include rook
#       "}
#       it 'should run' do
#         apply_manifest(pp, :catch_failures => true)
#       end

#       it 'should create rook namespace' do
#         run_shell('sleep 120')
#         run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl get namespaces | grep rook')
#       end

#       it 'should create rook operator ' do
#         run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook-system get pod | grep rook-operator') do |r|
#             expect(r.stdout).to match(/Running/)
#         end
#       end

#       it 'should create rook agent ' do
#         run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook-system get pod | grep rook-agent') do |r|
#             expect(r.stdout).to match(/Running/)
#         end
#       end

#       it 'should create rook cluster and verify rook-api' do
#         run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook get pod | grep rook-api') do |r|
#             expect(r.stdout).to match(/Running/)
#         end
#       end
#       it 'should create rook cluster and verify rook-ceph-mgr0' do
#         shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook get pod | grep rook-ceph-mgr0') do |r|
#             expect(r.stdout).to match(/Running/)
#         end
#       end
#       it 'should create rook cluster and verify rook-ceph-mon0' do
#         run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook get pod | grep rook-ceph-mon0') do |r|
#             expect(r.stdout).to match(/Running/)
#         end
#       end
#       it 'should create rook cluster and verify rook-ceph-mon1' do
#         run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook get pod | grep rook-ceph-mon1') do |r|
#             expect(r.stdout).to match(/Running/)
#         end
#       end
#       it 'should create rook cluster and verify rook-ceph-mon2' do
#         run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook get pod | grep rook-ceph-mon2') do |r|
#             expect(r.stdout).to match(/Running/)
#         end
#       end
#       it 'should create rook cluster and verify rook-ceph-osd' do
#         run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl -n rook get pod | grep rook-ceph-osd') do |r|
#             expect(r.stdout).to match(/Running/)
#         end
#       end
#       it 'should create storage class' do
#         run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubectl get storageclass | grep rook-block')
#       end
#       it 'should set default storage class' do
#         run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf;kubeget get storageclass | grep "rook-block (default)"')
#       end
#     end
#   end
end
