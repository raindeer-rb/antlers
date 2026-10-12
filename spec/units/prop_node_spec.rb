# frozen_string_literal: true

require_relative '../../lib/nodes/prop_node'
require_relative '../fixtures/props/prop_node'
dirload('spec/fixtures/props/prop_node.rbx')

# Render an Antlers node, which renders its corresponding named LowNode, which renders its Antlers template.
RSpec.describe Antlers::PropNode do
  describe '#render' do
    subject(:prop_node) { described_class.new(name: 'RBX::PropNode', namespace: 'RBX::PropNode') }

    context 'with RBX template' do
      it 'renders an instance variable' do
        expect(prop_node.render).to eq('<html>Instance Variable</html>')
      end
    end

    context 'with Ruby template' do
      subject(:prop_node) { described_class.new(name: 'Ruby::PropNode', namespace: 'Ruby::PropNode') }

      it 'renders an instance variable' do
        expect(prop_node.render).to eq('Instance Variable')
      end
    end
  end
end
