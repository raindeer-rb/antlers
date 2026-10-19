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

    context 'with a namespace containing a keyword' do
      let(:template) { '<{ Plain::Card size=2 }><{ Admin::Card: }>x<{ :Admin::Card }>' }

      it 'only splits on keywords that are whole words' do
        expect(lexer.parse(template:)).to eq(
          [{ prop: 'Plain::Card', props: { size: '2' } }, { slot_def: 'Admin::Card' }, 'x', { slot_end: 'Admin::Card' }]
        )
      end
    end

    context 'with a loop' do
      let(:template) { '<{ for: item in: items }>{item}<{ :for }>' }

      it 'still splits its keywords' do
        expect(lexer.parse(template:)).to eq([{ for_def: 'item', in: 'items' }, { var: 'item' }, { for_end: 'level_1' }])
      end
    end

    context 'with a variable' do
      let(:template) do
        <<~RUBY
          {"I'm just a string"}
        RUBY
      end

      it 'returns sequence' do
        expect(lexer.parse(template:)).to eq([{ var: %("I'm just a string") }])
      end
    end

    context 'with variables in text' do
      let(:template) do
        <<~HTML
          <p>
            Hello {name}, welcome {a} {b}
          </p>
        HTML
      end

      it 'preserves whitespace' do
        expect(lexer.parse(template:)).to eq(
          ["<p>\n  Hello ", { var: 'name' }, ', welcome ', { var: 'a' }, ' ', { var: 'b' }, "\n</p>"]
        )
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
            '<div class="', { var: '@mock_var' }, "\">\n  ",
              { prop: 'PropNode', props: { prop_with_val: 'mock_val', prop_without_val: nil } },
            "\n</div>"
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
        [{ for_def: 'value', in: 'array' }, "\n  ", { var: 'value' }, "\n", { for_end: 'level_1' }]
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
          [{ for_def: 'value', key: 'key', in: 'hash' }, "\n  ", { var: 'item' }, "\n", { for_end: 'level_1' }]
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
          ["<html>\n  ", { for_def: 'item', in: 'items' }, "\n    ", { var: 'item' }, "\n  ", { for_end: 'level_1' }, "\n</html>"]
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
        [{ form_def: %('/submit') }, "\n  <button>Submit</button>\n", { form_end: 'level_1' }]
      end

      it 'returns sequence' do
        expect(lexer.parse(template:)).to eq(sequence)
      end
    end

    context 'with a form node that has a variable action' do
      let(:template) do
        <<~RUBY
          <{ form: user }>
            <button>Submit</button>
          <{ :form }>
        RUBY
      end

      let(:sequence) do
        [{ form_def: 'user' }, "\n  <button>Submit</button>\n", { form_end: 'level_1' }]
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
        [{ form_def: nil }, "\n  <button>Submit</button>\n", { form_end: 'level_1' }]
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
        expect(lexer.parse(template:)).to eq([{ slot_def: 'SlotNode' }, "\n  ", { prop: 'PropNode' }, "\n", { slot_end: 'SlotNode' }])
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
