# frozen_string_literal: true

require 'erb'

require_relative '../interfaces/leaf_node'

module Antlers
  class VarNode < LeafNode
    attr_reader :value

    def initialize(name: :var, value:)
      super(name:)

      @value = value
    end

    def render(current_binding: nil, parent_binding: nil, slot_node: nil, namespace: nil)
      ERB::Util.html_escape(evaluate_value(current_binding))
    end

    private

    # A variable is deliberately limited in what it can represent.
    #  1. An instance/local variable
    #  2. A method call
    #  3. A static string
    def evaluate_value(current_binding)
      if current_binding
        return current_binding.receiver.instance_variable_get(@value) if @value.start_with?('@')
        return current_binding.local_variable_get(@value) if current_binding.local_variable_defined?(@value)
        return current_binding.receiver.send(@value.to_sym) if current_binding.receiver.respond_to?(@value.to_sym)
      end

      @value
    rescue NameError => e
      # TODO: Must be a better way to handle variables input as literal strings.
      @value
    end
  end
end
