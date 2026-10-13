# frozen_string_literal: true

require_relative '../../lib/nodes/form_node'

class MockFormClass
  def form_action
    '/users?tab=new&page=1'
  end

  def instance_binding
    binding
  end
end

RSpec.describe Antlers::FormNode do
  let(:mock_instance) { MockFormClass.new }

  describe '#render' do
    context 'with an action string' do
      subject(:form_node) { described_class.new(name: %('/submit'), action: %('/submit')) }

      it 'renders the static string' do
        expect(form_node.render(current_binding: mock_instance.instance_binding))
          .to eq("<form action='/submit' method='POST'></form>")
      end
    end

    context 'with an action variable' do
      subject(:form_node) { described_class.new(name: 'form_action', action: 'form_action') }

      it 'renders the evaluated variable' do
        expect(form_node.render(current_binding: mock_instance.instance_binding))
          .to eq("<form action='/users?tab=new&amp;page=1' method='POST'></form>")
      end
    end
  end
end
