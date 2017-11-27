require 'spec_helper'
describe 'rook::install' do
  context 'with rook alpha repo' do
    let (:title) {'rook-alpha'}

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
