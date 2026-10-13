# frozen_string_literal: true

module Antlers
  module Lexeme
    KEYWORDS = [].freeze

    def match?(name: nil, keywords: {}) = false

    def lexeme(name:, props:, keywords:, segment: nil, raw: false)
      raise NotImplementedError
    end

    private

    def props(props)
      odd_props = props.join(' ').split(/(=)|\s/)

      return {} unless odd_props.any?

      props = {}
      until odd_props.empty?
        prop = odd_props.shift
        value = nil

        if odd_props.first == '='
          odd_props.shift
          value = odd_props.shift
        end

        props[prop.to_sym] = value
      end

      props
    end
  end
end
