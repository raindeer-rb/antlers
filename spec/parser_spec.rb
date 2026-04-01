# frozen_string_literal: true

require_relative '../lib/parser'
require_relative '../lib/nodes/prop_node'
require_relative '../lib/nodes/root_node'
require_relative '../lib/nodes/var_node'

RSpec.describe Antlers::Parser do
  subject(:parser) { described_class }

  let(:var_node) do
    Antlers::VarNode.new(name: 'mock_var')
  end

  let(:prop_node) do
    Antlers::PropNode.new(name: 'PropNode', props: { 'prop_with_val' => 'mock_val', 'prop_without_val' => nil })
  end

  describe '.parse' do
    context 'with prop in slot' do
      let(:sequence) do
        [
          { slot_def: 'SlotNode' },
          { prop: 'PropNode', props: { 'prop_with_val' => 'mock_val', 'prop_without_val' => nil } },
          { slot_end: 'SlotNode' }
        ]
      end

      it 'returns AST' do
        slot_child = parser.parse(sequence).children.first

        expect(slot_child).to have_attributes(name: 'SlotNode', children: [prop_node])
      end
    end
  
    context 'with ivar and prop' do
      let(:sequence) do
        [
          { ivar: 'mock_var' },
          { prop: 'PropNode', props: { 'prop_with_val' => 'mock_val', 'prop_without_val' => nil } },
        ]
      end

      let(:ast) do
        [var_node, prop_node]
      end

      it 'returns AST' do
        expect(parser.parse(sequence).children).to eq(ast)
      end

      context 'when wrapped in HTML' do
        let(:sequence) do
          [
            '<div class="', { ivar: 'mock_var' }, '">',
              { prop: 'PropNode', props: { 'prop_with_val' => 'mock_val', 'prop_without_val' => nil } },
            '</div>'
          ]
        end

        let(:ast) do
          ['<div class="', var_node, '">', prop_node, '</div>']
        end

        it 'returns AST' do
          expect(parser.parse(sequence).children).to eq(ast)
        end
      end
    end
  end
end
