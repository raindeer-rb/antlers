# frozen_string_literal: true

require 'low_event'

# The class referenced via "<{ MyClass }>" must implement a "def self.render(event:)" method.
module Antlers
  module ClassRender
    def render(caller_binding: nil)
      props = evaluate_props(props: @props, caller_binding:)
      event = create_event(props:)

      klass = Object.const_get(name)
      klass.render(event:, **props)
    end

    private

    def create_event(props:)
      Low::Events::RenderEvent.new(action: :render, props:)
    end

    def evaluate_props(props:, caller_binding:)
      evaluated_props = {}

      props.each do |name, value|
        receiver = caller_binding.receiver
        
        if receiver.respond_to?(value.to_sym)
          evaluated_props[name] = receiver.send(value.to_sym) 
        elsif value.start_with?('@')
          evaluated_props[name] = receiver.instance_variable_get(value)
        end
      end

      evaluated_props
    end
  end
end
