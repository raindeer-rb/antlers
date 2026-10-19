# frozen_string_literal: true

require_relative '../../lib/nodes/prop_node'
require_relative '../fixtures/props/prop_node'
require_relative '../fixtures/props/single_prop_nodes'
require_relative '../fixtures/props/plain_nodes'
dirload('spec/fixtures/props/prop_node.rbx')

# Render an Antlers node, which renders its corresponding named LowNode, which renders its Antlers template.
RSpec.describe Antlers::PropNode do
  describe '#render' do
    subject(:prop_node) { described_class.new(name: 'RBX::PropNode', namespace: 'RBX::PropNode') }

    context 'with RBX template' do
      it 'renders an instance variable' do
        expect(prop_node.render).to eq('<html>Instance Variable</html>')
      end
    end

    context 'when Lowkey is cleared after the template is built' do
      it 'renders without looking up Lowkey' do
        prop_node
        Lowkey.clear(keep: false)

        expect(Lowkey).not_to receive(:[])
        expect(prop_node.render).to eq('<html>Instance Variable</html>')
      end
    end

    context 'when the class loads after the template is built' do
      subject(:prop_node) { described_class.new(name: 'RBX::LateCompNode', namespace: 'RBX::LateCompNode') }

      it 'is pending until the class loads and props are resolved' do
        # Prop nodes are equal when they're the same class, so compare identity.
        expect(described_class.pending).to include(be(prop_node))

        dirload('spec/fixtures/props/late_comp_node.rbx')
        expect(Antlers.resolve_nodes).not_to include(be(prop_node))

        Lowkey.clear(keep: false)
        expect(Lowkey).not_to receive(:[])
        expect(prop_node.render).to eq('<html>Late Instance Variable</html>')
      end
    end

    context 'when the class is not defined' do
      subject(:prop_node) { described_class.new(name: 'MissingNode') }

      it 'stays pending when props are resolved' do
        expect(Antlers.resolve_nodes).to include(be(prop_node))
      end

      it 'raises a name error on render' do
        expect { prop_node.render }.to raise_error(NameError, 'uninitialized constant MissingNode')
      end
    end

    context 'with a single prop' do
      it 'passes it to initialize' do
        prop_node = described_class.new(name: 'Ruby::InitializePropNode', namespace: 'Ruby::InitializePropNode', props: { limit: '3' })

        expect(prop_node.render).to eq('3 (Integer)')
      end

      it 'passes it to render' do
        prop_node = described_class.new(name: 'Ruby::RenderPropNode', namespace: 'Ruby::RenderPropNode', props: { limit: "'three'" })

        expect(prop_node.render).to eq('"three" (String)')
      end

      it 'passes a number from a template' do
        ast = Antlers.ast(template: '<{ Ruby::InitializePropNode limit=3 }>')

        expect(Antlers.render(ast:, current_binding: binding)).to eq('3 (Integer)')
      end
    end

    context 'with a plain Ruby class' do
      it 'gives initialize and render only the props each takes' do
        ast = Antlers.ast(template: "<{ Simple::PropNode limit=3 suffix='!' }>")

        expect(Antlers.render(ast:, current_binding: binding)).to eq('3!')
      end

      it 'gives render the slot as slot:' do
        ast = Antlers.ast(template: "<{ Simple::SlotNode: title='Notes' }><b>{name}</b><{ :Simple::SlotNode }>")
        current_binding = binding.tap { it.local_variable_set(:name, 'Mark') }

        expect(Antlers.render(ast:, current_binding:)).to eq('<section title="Notes"><b>Mark</b></section>')
      end
    end

    context 'with Ruby template' do
      subject(:prop_node) { described_class.new(name: 'Ruby::PropNode', namespace: 'Ruby::PropNode') }

      it 'renders an instance variable' do
        expect(prop_node.render).to eq('Instance Variable')
      end
    end
  end
end
