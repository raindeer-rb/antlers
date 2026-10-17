# frozen_string_literal: true

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
      @class_params = {}

      # Look up params on class load (when the template is built) so that rendering doesn't need Lowkey's cache.
      # A class defined in a file that hasn't loaded yet is pending until "Antlers.resolve_nodes" or its first render.
      PropNode.pending << self unless resolve
    end

    # Looks up the params of the prop's class when the class is defined.
    def resolve
      return false unless (klass = node_class)

      class_params(klass:)
      true
    end

    # Classes referenced via "<{ MyNode }>" must implement class/instance and render/render_template methods (See lownode).
    def render(current_binding: nil, parent_binding: nil, slot_node: nil, metadata: {})
      props = evaluate_props(props: @props, current_binding:)
      event = possible_render_event(props:)

      klass = node_class || raise(NameError, "uninitialized constant #{@name}")
      initialize_params, render_params = class_params(klass:)

      instance = create_instance(initialize_params:, klass:, event:, props:)
      return instance.render_template(event:, parent_binding:, props:) if klass.template

      render_args(render_params:, instance:, event:, props:)
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

    # Params are kept per class, so that a reloaded class has its params looked up again.
    # The class's file path is used as Lowkey loads a file path that has been cleared from its cache.
    def class_params(klass:)
      @class_params[klass] ||= begin
        file_path, = Object.const_source_location(klass.name)
        class_proxy = Lowkey[file_path][klass.name]

        %i[initialize render].map do |method_name|
          class_proxy.instance_methods[method_name]&.tagged_params(:keyword)&.map(&:name) || []
        end
      end
    end

    # Props are passed when the method takes any keyword besides event, like a single "limit:".
    def create_instance(initialize_params:, klass:, event:, props:)
      takes_props = (initialize_params - [:event]).any?
      return klass.new(event:, **props) if initialize_params.include?(:event) && takes_props
      return klass.new(**props) if takes_props
      return klass.new(event:) if initialize_params.include?(:event)

      klass.new
    end

    def render_args(render_params:, instance:, event:, props:)
      takes_props = (render_params - [:event]).any?
      return instance.render(event:, **props) if render_params.include?(:event) && takes_props
      return instance.render(**props) if takes_props
      return instance.render(event:) if render_params.include?(:event)

      instance.render
    end
  end
end
