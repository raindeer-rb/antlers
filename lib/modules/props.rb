# frozen_string_literal: true

module Antlers
  module Props
    attr_accessor :props

    def initialize(name:, props: {}, **)
      super(name:, **)

      @props = props
    end

    private

    def create_event(props:)
      Low::Events::RenderEvent.new(action: :render, props:)
    end

    def evaluate_props(props:, current_binding:)
      return {} if props.nil?

      evaluated_props = {}

      props.each do |name, value|
        receiver = current_binding.receiver
        
        if receiver.respond_to?(value.to_sym)
          evaluated_props[name] = receiver.send(value.to_sym) 
        elsif value.start_with?('@')
          evaluated_props[name] = receiver.instance_variable_get(value)
        end
      end

      evaluated_props
    end

    def class_from_namespace(namespace:, name:)
      return Object.const_get(name) if Object.const_defined?(name) || name.start_with?('::') || namespace.empty?

      namespace_with_name = [namespace, name].join('::')
      return Object.const_get(namespace_with_name) if Object.const_defined?(namespace_with_name)

      namespace.pop
      class_from_namespace(namespace:, name:)
    end
  end
end
