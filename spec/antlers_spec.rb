# frozen_string_literal: true

require_relative '../lib/antlers'

RSpec.describe Antlers do
  subject(:antlers) { described_class }

  describe '.parse' do
    before do
      allow(Antlers::Parser).to receive(:parse)
    end

    it 'call parser' do
      Antlers.parse('<{ MockNode }>')

      expect(Antlers::Parser).to have_received(:parse)
    end
  end
end
