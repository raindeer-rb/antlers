# frozen_string_literal: true

require_relative '../../lib/modules/props'

RSpec.describe Antlers::Props do
  subject(:node) do
    Class.new do
      include Antlers::Props

      def initialize(props:)
        @props = props
      end

      public :evaluate_props
    end.new(props:)
  end

  describe '#evaluate_props' do
    let(:items) { %i[one two] }
    let(:props) { { items: 'items' } }

    it 'keeps the evaluated object instead of escaping it to a string' do
      expect(node.evaluate_props(props:, current_binding: binding)).to eq(items:)
    end

    it 'reads number literals as numbers rather than variable names' do
      props = { count: '3', below: '-2', ratio: '1.5', name: "'3'" }

      expect(node.evaluate_props(props:, current_binding: binding)).to eq(count: 3, below: -2, ratio: 1.5, name: '3')
    end
  end
end
