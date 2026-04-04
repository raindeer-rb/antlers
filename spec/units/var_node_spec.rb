# frozen_string_literal: true

require_relative '../../lib/nodes/var_node'

class MockVarClass
  def initialize
    @ivar = "Instance Variable"
  end

  def method_call
    "Method Call"
  end

  def instance_binding
    binding
  end
end

RSpec.describe Antlers::VarNode do
  let(:mock_instance) { MockVarClass.new }

  describe '#render' do
    context 'with an instance variable' do
      subject(:var_node) { described_class.new(value: "@ivar") }

      it 'evaluates an instance variable' do
        expect(var_node.render(caller_binding: mock_instance.instance_binding)).to eq("Instance Variable")
      end
    end

    context 'with a method call' do
      subject(:var_node) { described_class.new(value: "method_call") }

      it 'evaluates a method call' do
        expect(var_node.render(caller_binding: mock_instance.instance_binding)).to eq("Method Call")
      end
    end

    context 'with a string' do
      subject(:var_node) { described_class.new(value: "I'm just a string") }

      it 'evaluates a string' do
        expect(var_node.render).to eq("I&#39;m just a string")
      end
    end
  end
end
