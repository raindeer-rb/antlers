# frozen_string_literal: true

require_relative '../lib/antlers'

RSpec.describe Antlers do
  subject(:antlers) { described_class }

  describe '.parse' do
    it 'call parser' do
      expect(Parser).to have_received(:parse)
    end
  end
end
