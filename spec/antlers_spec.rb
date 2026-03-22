# frozen_string_literal: true

require_relative '../lib/antlers'

RSpec.describe Antlers do
  subject(:antlers) { described_class }

  describe '.parse' do
    context 'with HTML' do
      let(:template) do
        <<~HTML
          <div class="page-not-found">
            <em>404</em>
          </div>
        HTML
      end

      it 'returns HTML' do
        expect(antlers.parse(template)).to eq(template)
      end
    end

    # context 'with Antlers'
    #   let(:template) do
    #     <<~HTML
    #       <div class="page-not-found">
    #         <em>404</em>
    #       </div>
    #     HTML
    #   end

    #   it 'returns HTML' do
    #     antlers.parse(template)
    #   end
    # end
  end
end
