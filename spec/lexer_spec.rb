# frozen_string_literal: true

require_relative '../lib/antlers/elements'
require_relative '../lib/antlers/lexer'

RSpec.describe Antlers::Lexer do
  subject(:lexer) { described_class.new(lexeme_types:) }

  let(:lexeme_types) { Antlers::Elements[:html, :form, :for, :if, :prop, :slot, :yield, :var][:lexeme] }

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
        expect(lexer.parse(template:)).to eq(["<div class=\"page-not-found\">\n  <em>404</em>\n</div>"])
      end
    end

    context 'with a variable' do
      let(:template) do
        <<~RUBY
          {"I'm just a string"}
        RUBY
      end

      it 'returns sequence' do
        expect(lexer.parse(template:)).to eq([{ var: "I'm just a string" }])
      end
    end

    context 'with an instance variable' do
      let(:template) do
        <<~RUBY
          {@ivar}
        RUBY
      end

      it 'returns sequence' do
        expect(lexer.parse(template:)).to eq([{ var: '@ivar' }])
      end
    end

    context 'with a prop node' do
      let(:template) do
        <<~RUBY
          <{ PropNode prop_with_val=mock_val prop_without_val }>
        RUBY
      end

      let(:sequence) do
        [{ prop: 'PropNode', props: { prop_with_val: 'mock_val', prop_without_val: nil } }]
      end

      it 'returns sequence' do
        expect(lexer.parse(template:)).to eq(sequence)
      end

      context 'when wrapped in HTML' do
        let(:template) do
          <<~RUBY
            <div class="{@mock_var}">
              <{ PropNode prop_with_val=mock_val prop_without_val }>
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
          expect(lexer.parse(template:)).to eq(sequence)
        end
      end
    end

    context 'with a for node' do
      let(:template) do
        <<~RUBY
          <{ for: value in: array }>
            {value}
          <{ :for }>
        RUBY
      end

      let(:sequence) do
        [{ for_def: 'value', in: 'array' }, { var: 'value' }, { for_end: 'level_1' }]
      end

      it 'returns sequence' do
        expect(lexer.parse(template:)).to eq(sequence)
      end

      context 'with a hash' do
        let(:template) do
          <<~RUBY
            <{ for: key, value in: hash }>
              {item}
            <{ :for }>
          RUBY
        end

        let(:sequence) do
          [{ for_def: 'value', key: 'key', in: 'hash' }, { var: 'item' }, { for_end: 'level_1' }]
        end

        it 'returns sequence' do
          expect(lexer.parse(template:)).to eq(sequence)
        end
      end

      context 'when wrapped in HTML' do
        let(:template) do
          <<~RUBY
            <html>
              <{ for: item in: items }>
                {item}
              <{ :for }>
            </html>
          RUBY
        end

        let(:sequence) do
          ['<html>', { for_def: 'item', in: 'items' }, { var: 'item' }, { for_end: 'level_1' }, '</html>']
        end

        it 'returns sequence' do
          expect(lexer.parse(template:)).to eq(sequence)
        end
      end
    end

    context 'with a form node' do
      let(:template) do
        <<~RUBY
          <{ form: '/submit' }>
            <button>Submit</button>
          <{ :form }>
        RUBY
      end

      let(:sequence) do
        [{ form_def: '/submit' }, '<button>Submit</button>', { form_end: 'level_1' }]
      end

      it 'returns sequence' do
        expect(lexer.parse(template:)).to eq(sequence)
      end
    end

    context 'with a keyword that has no value' do
      let(:template) do
        <<~RUBY
          <{ form: }>
            <button>Submit</button>
          <{ :form }>
        RUBY
      end

      let(:sequence) do
        [{ form_def: nil }, '<button>Submit</button>', { form_end: 'level_1' }]
      end

      it 'returns sequence' do
        expect(lexer.parse(template:)).to eq(sequence)
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
        expect(lexer.parse(template:)).to eq([{ slot_def: 'SlotNode' }, { prop: 'PropNode' }, { slot_end: 'SlotNode' }])
      end
    end

    context 'with a yield node' do
      let(:template) do
        <<~RUBY
          <{ :slot }>
        RUBY
      end

      it 'returns sequence' do
        expect(lexer.parse(template:)).to eq([{ slot: :default }])
      end
    end
  end
end
