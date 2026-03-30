# frozen_string_literal: true

require_relative '../lib/parser'
require_relative '../lib/nodes/prop_node'
require_relative '../lib/nodes/root_node'
require_relative '../lib/nodes/var_node'

RSpec.describe Antlers::Parser do
  subject(:parser) { described_class }

  describe '.parse' do
    context 'with Antlers + HTML' do
      let(:sequence) do
        [
          '<div class="', { ivar: 'mock_var' }, '">',
            { leaf: 'PropNode', props: { 'prop_with_val' => 'mock_val', 'prop_without_val' => nil } },
          '</div>'
        ]
      end

      let(:ast) do
        Antlers::RootNode.new(children: [
          '<div class="',
          Antlers::VarNode.new(name: 'mock_var'),
          '">',
          Antlers::PropNode.new(name: 'PropNode', props: { 'prop_with_val' => 'mock_val', 'prop_without_val' => nil }),
          '</div>'
        ])
      end

      it 'returns AST' do
        expect(parser.parse(sequence)).to eq(ast)
      end
    end
  end
end
