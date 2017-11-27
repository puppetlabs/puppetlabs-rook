require 'spec_helper'
describe 'rook::packages' do
  context 'with default values for all parameters' do

    rook_packages = [ 'ceph-common', 'ceph-fs-common']

    rook_packages.each do | package |
      it { should contain_package("#{package}")}
    end
  end
end
