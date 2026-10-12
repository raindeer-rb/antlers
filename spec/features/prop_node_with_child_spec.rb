# frozen_string_literal: true

require_relative '../../lib/nodes/prop_node'

dirload('spec/fixtures/props/prop_node_var.rbx')
dirload('spec/fixtures/props/prop_node_with_child.rbx')

RSpec.describe RBX::PropNodeWithChild do
  subject(:prop_node) { described_class }

  describe '#render' do
    it 'renders child with prop' do
      expect(prop_node.render.response.body.read).to eq('<html><strong>Parent Variable</strong></html>')
    end
  end
end
