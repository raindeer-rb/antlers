# frozen_string_literal: true

require_relative '../../lib/nodes/for_node'
require_relative '../../lib/nodes/var_node'

class MockForClass
  def initialize
    @ivar_items = %w[x y]
  end

  def items
    ['<a>', 'b']
  end

  def pairs
    { one: 1, two: 2 }
  end

  def none
    []
  end

  def instance_binding
    binding
  end
end

RSpec.describe Antlers::ForNode do
  let(:mock_instance) { MockForClass.new }

  describe '#render' do
    context 'with a method call' do
      subject(:for_node) do
        described_class.new(name: 'item', value: 'item', items: 'items', children: [Antlers::VarNode.new(value: 'item')])
      end

      it 'renders children for each item' do
        expect(for_node.render(current_binding: mock_instance.instance_binding)).to eq('&lt;a&gt;b')
      end
    end

    context 'with an instance variable' do
      subject(:for_node) do
        described_class.new(name: 'item', value: 'item', items: '@ivar_items', children: [Antlers::VarNode.new(value: 'item')])
      end

      it 'renders children for each item' do
        expect(for_node.render(current_binding: mock_instance.instance_binding)).to eq('xy')
      end
    end

    context 'with a key' do
      subject(:for_node) do
        described_class.new(
          name: 'value', key: 'key', value: 'value', items: 'pairs',
          children: [Antlers::VarNode.new(value: 'key'), Antlers::VarNode.new(value: 'value')]
        )
      end

      it 'renders children for each key and value' do
        expect(for_node.render(current_binding: mock_instance.instance_binding)).to eq('one1two2')
      end
    end

    context 'with no items' do
      subject(:for_node) do
        described_class.new(name: 'item', value: 'item', items: 'none', children: [Antlers::VarNode.new(value: 'item')])
      end

      it 'renders nothing' do
        expect(for_node.render(current_binding: mock_instance.instance_binding)).to eq('')
      end
    end
  end
end
