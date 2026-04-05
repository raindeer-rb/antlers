# frozen_string_literal: true

require 'lowload'
require 'low_node'

require_relative '../../lib/nodes/prop_node'
require_relative '../fixtures/low_node'

module Ruby
  class LowPropNode < LowNode
    def initialize(event:)
      @ivar = 'Instance Variable'
    end

    def render(event:)
      @ivar
    end
  end
end

# Loaded via LowLoad as it's RBX.
LowLoad.lowload('spec/fixtures/low_prop_node.rbx')

# We are testing that we can render a LowNode from Antlers, and indirectly testing that a LowNode can render itself (via Ruby or Antlers).
RSpec.describe Antlers::PropNode do
  let(:event) { 'mock event' }

  describe '#render' do
    subject(:prop_node) { described_class.new(name: 'RBX::LowPropNode') }

    it 'renders an instance variable' do
      expect(prop_node.render).to eq('<html>Instance Variable</html>')
    end

    context 'when low node is plain Ruby' do
      subject(:prop_node) { described_class.new(name: 'Ruby::LowPropNode') }

      it 'renders an instance variable' do
        expect(prop_node.render).to eq('Instance Variable')
      end
    end
  end
end
