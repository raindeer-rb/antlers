# frozen_string_literal: true

require_relative '../lib/antlers/elements'
require_relative '../lib/antlers/parser'

RSpec.describe Antlers::Parser do
  subject(:parser) { described_class.new(node_types:) }

  let(:node_types) { Antlers::Elements[:html, :for, :prop, :slot, :var, :yield][:node] }
  let(:var_node) { Antlers::VarNode.new(value: "I'm just a string") }
  let(:prop_node) { Antlers::PropNode.new(name: 'PropNode', props: { prop_with_val: 'mock_val', prop_without_val: nil }) }

  describe '.parse' do
    context 'with var' do
      it 'returns AST' do
        expect(parser.parse(sequence: [{ var: "I'm just a string" }]).children).to eq([var_node])
      end
    end

    context 'with instance variable' do
      it 'returns AST' do
        expect(parser.parse(sequence: [{ var: '@ivar' }]).children).to eq([Antlers::VarNode.new(value: '@ivar')])
      end
    end

    context 'with var and prop' do
      let(:sequence) do
        [
          { var: "I'm just a string" },
          { prop: 'PropNode', props: { prop_with_val: 'mock_val', prop_without_val: nil } }
        ]
      end

      it 'returns AST' do
        expect(parser.parse(sequence:).children).to eq([var_node, prop_node])
      end

      context 'when wrapped in HTML' do
        let(:sequence) do
          [
            '<div class="', { var: "I'm just a string" }, '">',
              { prop: 'PropNode', props: { prop_with_val: 'mock_val', prop_without_val: nil } },
            '</div>'
          ]
        end

        let(:ast) do
          [
            Antlers::HTMLNode.new(html: '<div class="'),
            var_node,
            Antlers::HTMLNode.new(html: '">'),
            prop_node,
            Antlers::HTMLNode.new(html: '</div>')
          ]
        end

        it 'returns AST' do
          expect(parser.parse(sequence:).children).to eq(ast)
        end
      end
    end

    context 'with for loop' do
      let(:sequence) do
        [{ for_def: 'value', in: 'items' }, { var: 'value' }, { for_end: 'level_1' }]
      end

      let(:for_node) do
        Antlers::ForNode.new(name: 'ForNode', value: 'value', items: 'items', children: [var_node])
      end

      it 'returns AST' do
        expect(parser.parse(sequence:).children).to eq([for_node])
      end

      it 'raises when the end tag is missing' do
        expect { parser.parse(sequence: sequence[0..1]) }.to raise_error(Antlers::Parser::ParserError, /Missing end tag/)
      end

      context 'with hash' do
        let(:sequence) do
          [{ for_def: 'value', key: 'key', in: 'hash' }, { var: 'item' }, { for_end: 'level_1' }]
        end

        let(:for_node) do
          Antlers::ForNode.new(name: 'ForNode', key: 'key', value: 'item', items: 'items', children: [var_node])
        end

        it 'returns AST' do
          expect(parser.parse(sequence:).children).to eq([for_node])
        end
      end
    end

    context 'with slot definition' do
      let(:sequence) do
        [
          { slot_def: 'SlotNode' },
          { prop: 'PropNode', props: { prop_with_val: 'mock_val', prop_without_val: nil } },
          { slot_end: 'SlotNode' }
        ]
      end

      it 'returns AST' do
        slot_child = parser.parse(sequence:).children.first

        expect(slot_child).to have_attributes(name: 'SlotNode', children: [prop_node])
      end
    end

    context 'with slot yield' do
      it 'returns AST' do
        slot_child = parser.parse(sequence: [{ slot: :default }]).children.first

        expect(slot_child).to be_an_instance_of(Antlers::YieldNode)
        expect(slot_child).to have_attributes(name: :default)
      end
    end
  end
end
