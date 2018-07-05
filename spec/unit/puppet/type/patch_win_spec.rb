require 'spec_helper'
require 'puppet/type/patch_win'

RSpec.describe 'the patch_win type' do
  it 'loads' do
    expect(Puppet::Type.type(:patch_win)).not_to be_nil
  end
end
