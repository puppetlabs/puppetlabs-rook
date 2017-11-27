require 'spec_helper'
describe 'rook' do
  context 'with default values for all parameters' do
    it { should contain_class('rook') }
    it { should contain_class('rook::packages') }
    it { should contain_class('rook::install') }
    it { should contain_class('rook::storage_class') }
  end
end
