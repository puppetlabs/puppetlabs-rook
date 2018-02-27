require 'spec_helper'
describe 'rook' do
  context 'with default values for all parameters' do
  let (:params) { {
    'env' => ['HOME=/root', 'KUBECONFIG=/root/admin.conf'],
    'path' => ['/usr/bin', '/bin'],
    'rook_channel' => 'rook-alpha',
    'repo_url' => 'http://charts.rook.io/alpha',
    } }
    let(:facts) { {
        operatingsystem: 'CentOS',
	osfamily: 'RedHat',  
	operatingsystemrelease: '7.4', 
        operatingsystemmajrelease: '7', 	
    }}
    it { should contain_class('rook') }
    it { should contain_class('rook::packages') }
    it { should contain_class('rook::storage_class') }
  end
end
