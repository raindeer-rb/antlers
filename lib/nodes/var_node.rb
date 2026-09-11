# frozen_string_literal: true

require 'erb'

require_relative '../interfaces/leaf_node'
require_relative '../modules/variables'

module Antlers
  class VarNode < LeafNode
    include Variables

    attr_reader :value

    def initialize(value:, name: :var, raw: false)
      super(name:)

      @value = value
      @raw = raw
    end

    def render(current_binding: nil, parent_binding: nil, slot_node: nil, metadata: {})
      result = evaluate(name: @value, current_binding:) || fallback(@value)

      return result if @raw

      ERB::Util.html_escape(result)
    end

    class << self
      def match?(segment:)
        segment[:var] || segment[:raw_var]
      end

      def build(segment:, **)
        new(value: segment[:var] || segment[:raw_var], raw: !!segment[:raw_var])
      end
    end
  end
end
