# frozen_string_literal: true

require 'lowload'

require_relative '../../lib/nodes/prop_node'
require_relative '../../lib/nodes/slot_node'
require_relative '../fixtures/mock_low_node'

class MockSlotParent < MockLowNode
  def initialize
    @ivar = "Instance Variable"
  end

  # Usuallly a low node instance calls an antlers node, passing in the instance's binding.
  # But in this unit test we call an antlers node directly and supply it our mock binding.
  def instance_binding = binding
end

# MockSlotNode is loaded via LowLoad as it's RBX.
LowLoad.lowload('spec/fixtures/mock_slot_node.rbx')

class MockPropNode < MockLowNode
  def render(event:, ivar:)
    ivar
  end
end

RSpec.describe Antlers::SlotNode do
  let(:mock_parent) { MockSlotParent.new }

  describe '#render' do
    context 'when slot has a prop' do
      subject(:slot_node) { described_class.new(name: 'MockSlotNode', children: [prop_node]) }
      subject(:prop_node) { Antlers::PropNode.new(name: 'MockPropNode') }

      it 'renders both slot and prop' do
        expect(slot_node.render(caller_binding: mock_parent.instance_binding)).to eq('Instance Variable')
      end
    end
  end
end
