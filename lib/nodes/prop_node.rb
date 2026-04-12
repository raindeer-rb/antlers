# frozen_string_literal: true

require_relative '../interfaces/leaf_node'
require_relative '../modules/props'

module Antlers
  class PropNode < LeafNode
    include Props

    def render(current_binding: nil, parent_binding: nil, slot_node: nil, namespace: nil)
      props = evaluate_props(props: @props, current_binding:)
      event = create_event(props:)

      klass = class_from_namespace(namespace: namespace&.split('::') || [], name: @name)
      instance = klass.new(event:)

      # Classes referenced via "<{ ChildNode }>" must implement class/instance render/render_template methods (See LowNode).
      return instance.render_template(event:, parent_binding:, props:) if klass.template

      props.empty? ? instance.render(event:) : instance.render(event:, **props)
    end
  end
end
