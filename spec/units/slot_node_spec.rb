# frozen_string_literal: true

require 'lowload'
require 'low_node'

require_relative '../../lib/nodes/prop_node'
require_relative '../../lib/nodes/slot_node'
require_relative '../fixtures/low_node'

# Try not to confuse LowNode "nodes" with Antlers AST "nodes".
module Low
  class ParentNode < MockLowNode
    def initialize
      @ivar = "Instance Variable"
    end

    # Usuallly a low node instance calls an antlers node, passing in the instance's binding.
    # But in this unit test we call an antlers node directly and supply it our mock binding.
    def instance_binding = binding
  end

  # Loaded via LowLoad as it's RBX.
  LowLoad.lowload('spec/fixtures/low_slot_node.rbx')

  class PropNode < LowNode
    def render(event:, ivar:)
      ivar
    end
  end
end

RSpec.describe Antlers::SlotNode do
  let(:mock_parent_node) { Low::ParentNode.new }

  describe '#render' do
    context 'when slot has a prop' do
      subject(:slot_node) { Antlers::SlotNode.new(name: 'Low::SlotNode', children: [prop_node]) }
      subject(:prop_node) { Antlers::PropNode.new(name: 'Low::PropNode') }

      it 'renders both slot and prop' do
        expect(slot_node.render(current_binding: mock_parent_node.instance_binding)).to eq('Instance Variable')
      end
    end
  end
end
