require 'spec_helper'

describe 'rook::packages' do
  context 'RedHat with default values for all parameters' do
    let(:facts) { on_supported_os['centos-7-x86_64'] }

    rook_packages = [ 'ceph-common', 'ceph-deploy']
    rook_packages.each do | package |
      it { should contain_package("#{package}") }
      it { should contain_class('epel') }
    end
  end

  context 'Debian with default values for all parameters' do
    # No Ubuntu version is officially support so `on_supported_os` cannot be used
    let(:facts) { { os: { name: 'Ubuntu' } } }

    rook_packages = [ 'ceph-common', 'ceph-fs-common']
    rook_packages.each do | package |
      it { should contain_package("#{package}") }
    end
  end
end
