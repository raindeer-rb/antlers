# frozen_string_literal: true

require_relative '../../../lib/nodes/slot_node'
require_relative '../../../lib/nodes/var_node'

dirload('spec/fixtures/slots/slot_node_with_prop.rbx')
dirload('spec/fixtures/layouts/layout_node_with_prop.rbx')

RSpec.describe RBX::SlotNodeWithProp do
  subject(:slot_node) { described_class }

  let(:namespace) { described_class.to_s }

  describe '#render' do
    context 'when slot has a prop' do
      it 'renders prop into yield' do
        expect(slot_node.render.response.body.read).to eq('<html>LayoutHappyYield</html>')
      end
    end
  end
end
