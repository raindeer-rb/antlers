# frozen_string_literal: true

require_relative '../antlers/keywords'
require_relative '../interfaces/leaf_node'
require_relative '../modules/namespace'
require_relative '../modules/props'

module Antlers
  class PropNode < LeafNode
    include Namespace
    include Props # Immediate parent ancestor that super() refers to.

    def initialize(name:, props: {}, namespace: nil, **)
      super(name:, props:)

      @namespace = namespace

      # A class defined in a file that hasn't loaded yet is pending until "Antlers.resolve_nodes" or its first render.
      PropNode.pending << self unless resolve
    end

    # Whether the prop's class is defined.
    def resolve
      !node_class.nil?
    end

    # Classes referenced via "<{ MyNode }>" must implement class/instance and render/render_template methods (See lownode).
    def render(current_binding: nil, parent_binding: nil, slot_node: nil, metadata: {})
      props = evaluate_props(props: @props, current_binding:)
      event = possible_render_event(props:)

      klass = node_class || raise(NameError, "uninitialized constant #{@name}")

      # Initialize and render each get the props they take, and the event if they take it.
      keywords = props.merge(event:)
      instance = klass.new(**Keywords.accepted(klass.instance_method(:initialize), keywords))
      return instance.render_template(event:, parent_binding:, props:) if klass.respond_to?(:template) && klass.template

      instance.render(**Keywords.accepted(instance.method(:render), keywords))
    end

    class << self
      # Prop nodes whose class wasn't defined when their template was built.
      def pending
        @pending ||= []
      end

      # Resolves pending prop nodes once every class has loaded, returning those whose class is still undefined.
      def resolve
        pending.reject!(&:resolve)
        pending
      end

      def match?(segment:)
        segment[:prop]
      end

      def build(segment:, namespace:, **)
        new(name: segment[:prop], props: segment[:props], namespace:)
      end
    end

    private

    def node_class
      class_constant(namespace: @namespace&.split('::') || [], name: @name)
    end
  end
end
