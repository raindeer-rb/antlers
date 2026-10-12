# frozen_string_literal: true

require_relative '../../../lib/nodes/if_node'

dirload('spec/fixtures/ifs/if_node.rbx')

RSpec.describe RBX::IfNode do
  subject(:if_node) { described_class.render(event: nil, boolean:) }

  describe '<{ if: }>' do
    context 'when true' do
      let(:boolean) { true }

      it 'returns response' do
        expect(if_node.response.body.read).to eq(
          <<~HTML.squish
            <p>Yes</p>
          HTML
        )
      end
    end

    context 'when false' do
      let(:boolean) { false }

      it 'returns nil' do
        expect(if_node).to eq(nil)
      end
    end
  end
end
