# frozen_string_literal: true

require_relative '../interfaces/branch_node'
require_relative '../modules/props'

module Antlers
  class SlotNode < BranchNode
    include Props

    attr_accessor :children

    def initialize(name:, props: [], children: [])
      super(name:, props:, children:)
    end

    def render(current_binding: nil, parent_binding: nil, slot_node: nil, namespace: nil)
      props = evaluate_props(props: @props, current_binding:)
      event = create_event(props:)

      klass = class_from_namespace(namespace: namespace&.split('::') || [], name: @name)
      instance = klass.new(event:)

      # Classes referenced via "<{ ChildNode }>" must implement class/instance render/render_template methods (See LowNode).
      return instance.render_template(event:, parent_binding: current_binding, slot_node: self, props:) if klass.template

      props.empty? ? instance.render(event:) : instance.render(event:, **props)
    end
  end
end
