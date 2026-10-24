# frozen_string_literal: true

module Antlers
  class AntlerNode
    attr_reader :name

    DEF_KEY = nil
    END_KEY = nil

    def initialize(name:)
      @name = name
    end

    def render(current_binding: nil, parent_binding: nil, slot_node: nil, namespace: nil, metadata: {})
      raise NotImplementedError
    end

    def end_name
      'level_1'
    end

    # Support sending an event to render_template hook when lowevent available. See lownode as an example implementation.
    def possible_render_event(props:, current_binding: nil)
      return unless defined?(Low::Events::RenderEvent)
      return Low::Events::RenderEvent.new(action: :render, props:) unless Low::Events::RenderEvent.members.include?(:params)

      Low::Events::RenderEvent.new(action: :render, props:, params: parent_params(current_binding:))
    end

    # The parent node's event (a RouteEvent or RenderEvent) is the "event" local variable on its binding.
    def parent_params(current_binding:)
      return {} unless current_binding&.local_variable_defined?(:event)

      event = current_binding.local_variable_get(:event)
      (event.params if event.respond_to?(:params)) || {}
    end

    class << self
      def match?(segment:)
        raise NotImplementedError
      end

      def build(segment:, namespace:)
        raise NotImplementedError
      end
    end

    # Compare instance as a value object.
    def ==(other) = other.class == self.class
    def eql?(other) = self == other
    def hash = [self.class].hash
  end
end
