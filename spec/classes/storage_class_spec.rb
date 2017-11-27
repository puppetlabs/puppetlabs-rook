require 'spec_helper'
describe 'rook::storage_class' do
  context 'with default values for all parameters' do

    helm_files = ['rook-cluster.yaml', 'rook-storage.yaml']

    helm_files.each do | file |
      it { should contain_file("/tmp/#{file}").with({ :ensure => 'present' })}
    end

    it { should contain_exec('Create rook namespace').with_command('kubectl create namespace rook') }
    it { should contain_exec('Create rook cluster').with_command('kubectl create -f rook-cluster.yaml') }
    it { should contain_exec('Create storage class').with_command('kubectl create -f rook-storage.yaml') }
  end
end
