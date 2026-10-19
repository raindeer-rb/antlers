# frozen_string_literal: true

require_relative '../../lib/antlers/keywords'

RSpec.describe Antlers::Keywords do
  let(:keywords) { { limit: 3, suffix: '!', event: 'event' } }

  def method_with(&) = Class.new { define_method(:call, &) }.instance_method(:call)

  describe '.accepted' do
    it 'gives a method the optional and required keywords it declares' do
      expect(described_class.accepted(method_with { |event:, limit: 5| [event, limit] }, keywords)).to eq(limit: 3, event: 'event')
    end

    it 'gives a method that takes ** every keyword' do
      expect(described_class.accepted(method_with { |**| nil }, keywords)).to eq(keywords)
    end

    it 'gives a method without keywords none' do
      expect(described_class.accepted(method_with { nil }, keywords)).to eq({})
    end
  end

  describe '.takes?' do
    it 'is whether the method declares the keyword or takes **' do
      expect(described_class.takes?(method_with { |slot: nil| slot }, :slot)).to be(true)
      expect(described_class.takes?(method_with { |**| nil }, :slot)).to be(true)
      expect(described_class.takes?(method_with { |limit: 5| limit }, :slot)).to be(false)
    end
  end
end
