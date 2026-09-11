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
    end

    # Classes referenced via "<{ MyNode }>" must implement class/instance and render/render_template methods (See LowNode).
    def render(current_binding: nil, parent_binding: nil, slot_node: nil, metadata: {})
      props = evaluate_props(props: @props, current_binding:)
      event = create_render_event(props:)

      # TODO: Get LowLoad to load constants defined in "<{ MyNode }>" syntax so that we can resolve namespace/params on class load.
      klass = class_constant(namespace: @namespace&.split('::') || [], name: @name)
      class_proxy = Lowkey[klass.to_s].first[klass.to_s]

      instance = create_instance(class_proxy:, klass:, event:, props:)
      return instance.render_template(event:, parent_binding:, props:) if klass.template

      render_args(class_proxy:, instance:, event:, props:)
    end

    class << self
      def match?(segment:)
        segment[:prop]
      end

      def build(segment:, namespace:, **)
        new(name: segment[:prop], props: segment[:props], namespace:)
      end
    end

    private

    def create_instance(class_proxy:, klass:, event:, props:)
      initialize_params = class_proxy.instance_methods[:initialize]&.tagged_params(:keyword)&.map(&:name) || []

      return klass.new(event:, **props) if initialize_params.include?(:event) && initialize_params.count > 1
      return klass.new(**props) if initialize_params.count > 1
      return klass.new(event:) if initialize_params.include?(:event)

      klass.new
    end

    def render_args(class_proxy:, instance:, event:, props:)
      render_params = class_proxy.instance_methods[:render]&.tagged_params(:keyword)&.map(&:name) || []
      return instance.render(event:, **props) if render_params.include?(:event) && render_params.count > 1
      return instance.render(event:) if render_params.include?(:event)

      instance.render
    end
  end
end
