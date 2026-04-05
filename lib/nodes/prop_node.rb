# frozen_string_literal: true

require_relative '../interfaces/leaf_node'
require_relative '../modules/props'

module Antlers
  class PropNode < LeafNode
    include Props

    def render(current_binding: nil, parent_binding: nil, namespace: nil)
      props = evaluate_props(props: @props, current_binding:)
      event = create_event(props:)

      # TODO: Namespace lookup similar to what LowLoad does.
      klass = Object.const_get(name)

      instance = klass.new(event:)
      klass.template ? instance.render_template(event:, parent_binding:) : instance.render(event:)
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
  end
end
