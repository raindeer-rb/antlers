# frozen_string_literal: true

require_relative '../interfaces/leaf_node'
require_relative '../modules/variables'
require_relative '../antlers/translations'
require_relative '../support/queries'

module Antlers
  class VarNode < LeafNode
    include Variables

    attr_reader :value

    def initialize(value:, name: :var, raw: false)
      super(name:)

      @value = value
      @raw = raw
      @translatable = Queries.translatable?(value.strip)
    end

    def render(current_binding: nil, parent_binding: nil, slot_node: nil, metadata: {})
      return evaluate(value: @value, current_binding:, escape: !@raw).to_s unless @translatable

      result = Translations.translate(result(value: @value, current_binding:))
      (@raw ? result : ERB::Util.html_escape(result)).to_s
    end

    class << self
      def match?(segment:)
        segment[:var] || segment[:raw_var]
      end

      def build(segment:, **)
        new(value: segment[:var] || segment[:raw_var], raw: !segment[:raw_var].nil?)
      end
    end
  end
end
