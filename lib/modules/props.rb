# frozen_string_literal: true

require_relative 'variables'

module Antlers
  module Props
    include Variables

    attr_accessor :props

    def initialize(name:, props: {}, **)
      super(name:, **)

      @props = props
    end

    private

    def evaluate_props(props:, current_binding:)
      return {} if props.nil?

      evaluated_props = {}

      props.each do |name, value|
        evaluated_props[name] = evaluate(name: value, current_binding:) || fallback(value)
      end

      evaluated_props
    end
  end
end
