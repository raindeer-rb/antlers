# frozen_string_literal: true

require 'lowload'
require 'low_node'

require_relative '../../lib/nodes/prop_node'
require_relative '../../lib/nodes/slot_node'
require_relative '../fixtures/low_node'

LowLoad.lowload('spec/fixtures/slot_node_with_child.rbx')
LowLoad.lowload('spec/fixtures/prop_node_var.rbx')
LowLoad.lowload('spec/fixtures/yield_node.rbx')

RSpec.describe RBX::SlotNodeWithChild do
  subject(:parent_node) { described_class }

  let(:event) { 'mock event' }

  describe '#render' do
    context 'when slot has a prop node' do
      subject(:slot_node) { Antlers::SlotNode.new(name: 'RBX::YieldNode', children: [prop_node]) }
      subject(:prop_node) { Antlers::PropNode.new(name: 'RBX::PropNodeVar') }

      it 'renders both slot and prop node' do
        expect(parent_node.render(event:).response.body.read).to eq('<html><strong>Parent Variable</strong></html>')
      end
    end
  end
end
