# frozen_string_literal: true

require_relative '../../../lib/nodes/form_node'

dirload('spec/fixtures/forms/basic_form_node.rbx')

RSpec.describe RBX::BasicFormNode do
  subject(:form_node) { described_class }

  describe '<{ form: }>' do
    it 'renders form' do
      expect(form_node.render.response.body.read.squish).to eq(
        <<~HTML.squish
          <form action='/submit' method='POST'>
            <button>Submit</button>
          </form>
        HTML
      )
    end
  end
end
