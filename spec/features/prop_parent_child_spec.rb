# frozen_string_literal: true

require 'lowload'
require 'low_node'

require_relative '../../lib/nodes/prop_node'

LowLoad.lowload('spec/fixtures/child_node.rbx')
LowLoad.lowload('spec/fixtures/parent_node.rbx')

RSpec.describe 'Pass props from parent to child' do
  let(:event) { 'mock event' }

  describe '#render' do
    it 'renders child with prop' do
      expect(RBX::ParentNode.render(event:).response.body.read).to eq('<html><strong>Parent Variable</strong></html>')
    end
  end
end
