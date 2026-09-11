# frozen_string_literal: true

require_relative '../interfaces/branch_node'
require_relative '../modules/namespace'
require_relative '../modules/props'

module Antlers
  class SlotNode < BranchNode
    include Namespace
    include Props # The immediate ancestor which props are passed to.

    DEF_KEY = :slot_def
    END_KEY = :slot_end

    attr_accessor :children

    def initialize(name:, namespace:, props: {}, children: [], **)
      super(name:, props:, children:)

      @namespace = namespace
    end

    def render(current_binding: nil, parent_binding: nil, slot_node: nil, metadata: {})
      props = evaluate_props(props: @props, current_binding:)
      event = create_render_event(props:)

      # TODO: Get LowLoad to load constants defined in "<{ MyNode }>" syntax so that we can resolve namespace/params on class load.
      klass = class_constant(namespace: @namespace&.split('::') || [], name:)
      instance = klass.new(event:)

      # Classes referenced via "<{ ChildNode }>" must implement class/instance render/render_template methods (See LowNode).
      return instance.render_template(event:, parent_binding: current_binding, slot_node: self, props:) if klass.template

      props.empty? ? instance.render(event:) : instance.render(event:, **props)
    end

    def end_name
      @name
    end

    class << self
      def match?(segment:)
        segment[DEF_KEY]
      end

      def build(segment:, namespace:, **)
        new(name: segment[DEF_KEY], props: segment[:props], namespace:)
      end
    end
  end
end
