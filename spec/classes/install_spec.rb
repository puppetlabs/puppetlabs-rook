require 'spec_helper'
describe 'rook::install' do
  context 'with rook alpha repo' do
    let (:title) {'rook-alpha'}
    let (:params) { {
      'env' => ['HOME=/root', 'KUBECONFIG=/root/admin.conf'],
      'path' => ['/usr/bin', '/bin'],
      'rook_channel' => 'rook-alpha',
      'repo_url' => 'http://charts.rook.io/alpha'
      }}

    env = [ 'HOME=/root', 'KUBECONFIG=/root/admin.conf']
    path = ['/usr/bin', '/bin']

      it { should contain_helm__repo('rook-alpha').with({
        :ensure => 'present',
        :env => "#{env}",
        :path => "#{path}",
        :repo_name => 'rook-alpha',
        :url => 'http://charts.rook.io/alpha',
        :before => 'Helm::Chart[rook]',
        })
      }
    end
end
