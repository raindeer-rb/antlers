# frozen_string_literal: true

require_relative '../lib/lexer'

RSpec.describe Antlers::Lexer do
  subject(:lexer) { described_class.new }

  describe '.parse' do
    context 'with HTML' do
      let(:template) do
        <<~HTML
          <div class="page-not-found">
            <em>404</em>
          </div>
        HTML
      end

      let(:sequence) do
        ["<div class=\"page-not-found\">\n  <em>404</em>\n</div>"]
      end

      it 'returns sequence' do
        expect(lexer.parse(template)).to eq(sequence)
      end
    end

    context 'with Antlers' do
      let(:template) do
        <<~RUBY
          <{ PropNode prop_with_val=mock_val prop_without_val if: @user.happy? }>
        RUBY
      end

      let(:sequence) do
        [{ name: 'PropNode', props: { 'prop_with_val' => 'mock_val', 'prop_without_val' => nil } }]
      end

      it 'returns sequence' do
        expect(lexer.parse(template)).to eq(sequence)
      end
    end

    context 'with Antlers + HTML' do
      let(:template) do
        <<~RUBY
          <div class="{@mock_var}">
            <{ PropNode prop_with_val=mock_val prop_without_val if: @user.happy? }>
          </div>
        RUBY
      end

      let(:sequence) do
        [
          '<div class="', { ivar: 'mock_var' }, '">',
            { name: 'PropNode', props: { 'prop_with_val' => 'mock_val', 'prop_without_val' => nil } },
          '</div>'
        ]
      end

      it 'returns sequence' do
        expect(lexer.parse(template)).to eq(sequence)
      end
    end
  end
end
