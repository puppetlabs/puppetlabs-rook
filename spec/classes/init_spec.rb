require 'spec_helper'

describe 'rook' do
  context 'with default values for all parameters' do
    let (:params) { {
      'env' => ['HOME=/root', 'KUBECONFIG=/root/admin.conf'],
      'path' => ['/usr/bin', '/bin'],
      'version' => 'v0.7.0',
    } }
    let(:facts) { on_supported_os['centos-7-x86_64'] }

    it { should contain_class('rook') }
    it { should contain_class('rook::packages') }
    it { should contain_class('rook::storage_class') }
  end
end
