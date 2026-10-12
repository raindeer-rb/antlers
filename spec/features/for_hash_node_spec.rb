# frozen_string_literal: true

dirload('spec/fixtures/for_node_hash.rbx')

RSpec.describe RBX::ForNodeHash do
  subject(:for_node) { described_class }

  describe '<{ for: key, value in: @items }>' do
    it 'renders items' do
      expect(RBX::ForNodeHash.render.response.body.read).to eq(
        <<~HTML.squish
          <ul>
            <li>one:1</li>
            <li>two:2</li>
            <li>three:3</li>
          </ul>
        HTML
      )
    end
  end
end
