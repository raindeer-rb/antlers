# frozen_string_literal: true

dirload('spec/fixtures/namespaces/child_node.rbx')
dirload('spec/fixtures/namespaces/layout_node.rbx')
dirload('spec/fixtures/namespaces/namespaced_child_node.rbx')
dirload('spec/fixtures/namespaces/namespaced_layout_node.rbx')

RSpec.describe 'Namespaces' do
  let(:event) { 'mock event' }

  context 'without namespace' do
    it 'resolves to layout' do
      expect(ChildNode.render.response.body.read).to eq(
        <<~HTML.squish
          <html class="without-namespace">
            <p></p>
          </html>
        HTML
      )
    end
  end

  context 'with namespace' do
    it 'resolves to namespaced layout' do
      expect(Namespace::ChildNode.render.response.body.read).to eq(
        <<~HTML.squish
          <html class="with-namespace">
            <p></p>
          </html>
        HTML
      )
    end
  end
end
