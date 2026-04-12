# frozen_string_literal: true

require_relative '../lib/lexer'

RSpec.describe Antlers::Lexer do
  subject(:lexer) { described_class.new }

  describe '.parse' do
    context 'when just HTML' do
      let(:template) do
        <<~HTML
          <div class="page-not-found">
            <em>404</em>
          </div>
        HTML
      end

      it 'returns sequence' do
        expect(lexer.parse(template)).to eq(["<div class=\"page-not-found\">\n  <em>404</em>\n</div>"])
      end
    end

    context 'with a variable' do
      let(:template) do
        <<~RUBY
          {"I'm just a string"}
        RUBY
      end

      it 'returns sequence' do
        expect(lexer.parse(template)).to eq([{ var: "I'm just a string" }])
      end
    end

    context 'with an instance variable' do
      let(:template) do
        <<~RUBY
          {@ivar}
        RUBY
      end

      it 'returns sequence' do
        expect(lexer.parse(template)).to eq([{ var: "@ivar" }])
      end
    end

    context 'with a prop node' do
      let(:template) do
        <<~RUBY
          <{ PropNode prop_with_val=mock_val prop_without_val if: @user.happy? }>
        RUBY
      end

      let(:sequence) do
        [{ prop: 'PropNode', props: { prop_with_val: 'mock_val', prop_without_val: nil } }]
      end

      it 'returns sequence' do
        expect(lexer.parse(template)).to eq(sequence)
      end

      context 'when wrapped in HTML' do
        let(:template) do
          <<~RUBY
            <div class="{@mock_var}">
              <{ PropNode prop_with_val=mock_val prop_without_val if: @user.happy? }>
            </div>
          RUBY
        end

        let(:sequence) do
          [
            '<div class="', { var: '@mock_var' }, '">',
              { prop: 'PropNode', props: { prop_with_val: 'mock_val', prop_without_val: nil } },
            '</div>'
          ]
        end

        it 'returns sequence' do
          expect(lexer.parse(template)).to eq(sequence)
        end
      end
    end

    context 'with a slot node' do
      let(:template) do
        <<~RUBY
          <{ SlotNode: }>
            <{ PropNode }>
          <{ :SlotNode }
        RUBY
      end

      it 'returns sequence' do
        expect(lexer.parse(template)).to eq([{ slot_def: 'SlotNode' }, { prop: 'PropNode' }, { slot_end: 'SlotNode' }])
      end
    end

    context 'with a yield node' do
      let(:template) do
        <<~RUBY
          <{ :slot }>
        RUBY
      end

      it 'returns sequence' do
        expect(lexer.parse(template)).to eq([{ slot: :default }])
      end
    end
  end
end
