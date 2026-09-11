# frozen_string_literal: true

require_relative '../interfaces/branch_node'
require_relative '../modules/props'
require_relative '../modules/variables'

module Antlers
  class FormNode < BranchNode
    include Props
    include Variables

    DEF_KEY = :form_def
    END_KEY = :form_end

    def initialize(name:, action: nil, method: 'POST', props: [], children: [])
      super(name:, props:, children:)

      @action = action
      @method = method
    end

    def render(current_binding: nil, parent_binding: nil, slot_node: nil, metadata: {})
      output = "<form action='#{@action}' method='#{@method}'>"

      @children.each do |child|
        output += child.render(current_binding:, parent_binding:, slot_node:, metadata:) || ''
      end

      output += '</form>'
      output
    end

    class << self
      def match?(segment:)
        segment[DEF_KEY]
      end

      def build(segment:, **)
        action, method = segment.values_at(DEF_KEY, :method)
        return new(name: action, action:, method:) if method

        new(name: action, action:)
      end
    end
  end
end
