# frozen_string_literal: true

require_relative '../../lib/nodes/prop_node'
require_relative '../fixtures/mock_low_node'

# Pass a variable from parent...
class MockPropParent < MockLowNode
  def initialize
    @ivar = "Instance Variable"
  end

  # Usuallly a low node instance calls an antlers node, passing in the instance's binding.
  # But in this unit test we call an antlers node directly and supply it our mock binding.
  def instance_binding = binding
end

# ...to child...
class MockPropChild < MockLowNode
  def render(event:, ivar:)
    ivar
  end
end

# ...through a PropNode.
RSpec.describe Antlers::PropNode do
  let(:mock_parent) { MockPropParent.new }

  describe '#render' do
    context 'with an instance variable' do
      subject(:prop_node) { described_class.new(name: 'MockPropChild', props: { ivar: '@ivar' }) }

      it 'evaluates an instance variable' do
        expect(prop_node.render(caller_binding: mock_parent.instance_binding)).to eq('Instance Variable')
      end
    end
  end
end
