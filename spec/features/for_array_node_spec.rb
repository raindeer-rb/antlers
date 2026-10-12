# frozen_string_literal: true

dirload('spec/fixtures/for_node_array.rbx')

RSpec.describe RBX::ForNodeArray do
  subject(:for_node) { described_class }

  describe '<{ for: value in: @items }>' do
    it 'renders value' do
      expect(RBX::ForNodeArray.render.response.body.read).to eq(
        <<~HTML.squish
          <ul>
            <li>1</li>
            <li>2</li>
            <li>3</li>
          </ul>
        HTML
      )
    end
  end
end
