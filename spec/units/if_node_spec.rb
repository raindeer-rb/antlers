# frozen_string_literal: true

require_relative '../../lib/nodes/if_node'
require_relative '../../lib/nodes/var_node'

class MockIfClass
  def initialize
    @ivar = true
  end

  def truthy = true
  def falsy = false
  def empty = nil

  def method_parent
    Struct.new(:method_child).new(false)
  end

  def instance_binding
    binding
  end
end

RSpec.describe Antlers::IfNode do
  let(:mock_instance) { MockIfClass.new }
  let(:children) { [Antlers::VarNode.new(value: "'Shown'")] }

  describe '#render' do
    context 'with a truthy method call' do
      subject(:if_node) { described_class.new(name: 'truthy', value: 'truthy', children:) }

      it 'renders children' do
        expect(if_node.render(current_binding: mock_instance.instance_binding)).to eq('Shown')
      end
    end

    context 'with a truthy instance variable' do
      subject(:if_node) { described_class.new(name: '@ivar', value: '@ivar', children:) }

      it 'renders children' do
        expect(if_node.render(current_binding: mock_instance.instance_binding)).to eq('Shown')
      end
    end

    context 'with a false method call' do
      subject(:if_node) { described_class.new(name: 'falsy', value: 'falsy', children:) }

      it 'does not render children' do
        expect(if_node.render(current_binding: mock_instance.instance_binding)).to eq('')
      end
    end

    context 'with a nil method call' do
      subject(:if_node) { described_class.new(name: 'empty', value: 'empty', children:) }

      it 'does not render children' do
        expect(if_node.render(current_binding: mock_instance.instance_binding)).to eq('')
      end
    end

    context 'with a false method chain' do
      subject(:if_node) { described_class.new(name: 'method_parent', value: 'method_parent.method_child', children:) }

      it 'does not render children' do
        expect(if_node.render(current_binding: mock_instance.instance_binding)).to eq('')
      end
    end

    context 'with an undefined variable' do
      subject(:if_node) { described_class.new(name: 'undefined', value: 'undefined', children:) }

      it 'does not render children' do
        expect(if_node.render(current_binding: mock_instance.instance_binding)).to eq('')
      end
    end
  end
end
