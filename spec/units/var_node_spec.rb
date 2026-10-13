# frozen_string_literal: true

require 'date'
require 'ostruct'
require_relative '../../lib/nodes/var_node'

class MockVarClass
  def initialize
    @ivar = 'Instance Variable'
  end

  # NOTE: Currently not in use.
  # TODO: Support Ruby code followed by Antlers code in a render method via LowNode/LowLoad, thus setting up a local variable.
  def local_var
    var = 'Local Variable'
    binding
  end

  def method_call
    'Method Call'
  end

  def method_parent
    OpenStruct.new({ method_child: true })
  end

  def published_at
    DateTime.new(2026, 10, 13, 9, 30)
  end

  def instance_binding
    binding
  end
end

RSpec.describe Antlers::VarNode do
  let(:mock_instance) { MockVarClass.new }

  describe '#render' do
    context 'with an instance variable' do
      subject(:var_node) { described_class.new(value: '@ivar') }

      it 'evaluates an instance variable' do
        expect(var_node.render(current_binding: mock_instance.instance_binding)).to eq('Instance Variable')
      end
    end

    context 'with a local variable' do
      subject(:var_node) { described_class.new(value: 'var') }

      it 'evaluates a local variable' do
        expect(var_node.render(current_binding: mock_instance.local_var)).to eq('Local Variable')
      end
    end

    context 'with a method call' do
      subject(:var_node) { described_class.new(value: 'method_call') }

      it 'evaluates a method call' do
        expect(var_node.render(current_binding: mock_instance.instance_binding)).to eq('Method Call')
      end
    end

    context 'with a method chain' do
      subject(:var_node) { described_class.new(value: 'method_parent.method_child') }

      it 'evaluates a method chain' do
        expect(var_node.render(current_binding: mock_instance.instance_binding)).to eq('true')
      end
    end

    context 'with an object' do
      subject(:var_node) { described_class.new(value: 'published_at', raw: true) }

      it 'renders a string' do
        expect(var_node.render(current_binding: mock_instance.instance_binding)).to eq('2026-10-13T09:30:00+00:00')
      end
    end

    context 'with a string' do
      subject(:var_node) { described_class.new(value: "I'm just a string") }

      it 'evaluates a string' do
        expect(var_node.render).to eq('I&#39;m just a string')
      end
    end
  end
end
