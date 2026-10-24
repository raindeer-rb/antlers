# frozen_string_literal: true

require_relative '../antlers/keywords'
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
      event = possible_render_event(props:, current_binding:)

      klass = class_constant(namespace: @namespace&.split('::') || [], name:)
      keywords = props.merge(event:)
      instance = klass.new(**Keywords.accepted(klass.instance_method(:initialize), keywords))

      # Classes referenced via "<{ ChildNode }>" must implement class/instance render/render_template methods (See LowNode).
      if klass.respond_to?(:template) && klass.template
        return instance.render_template(event:, parent_binding: current_binding, slot_node: self, props:)
      end

      # Without a class template, a component's own render method can receive its slot's rendered children as slot:.
      render_method = instance.method(:render)
      keywords[:slot] = slot(current_binding:, metadata:) if Keywords.takes?(render_method, :slot)
      instance.render(**Keywords.accepted(render_method, keywords))
    end

    # The children rendered in the binding the slot is in, like a yield in a template renders them.
    def slot(current_binding:, metadata:)
      @children.map { |child| child.render(current_binding:, parent_binding: current_binding, slot_node: self, metadata:) || '' }.join
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
