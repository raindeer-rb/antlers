# frozen_string_literal: true

require 'erb'

require_relative '../interfaces/antler_node'

module Antlers
  class VarNode < AntlerNode
    attr_reader :value

    def initialize(name: :var, value:)
      super(name:)

      @value = value
    end

    # A variable is deliberately limited in what it can represent.
    #  1. An instance/local variable
    #  2. A method call
    #  3. A static string
    def render(caller_binding: nil)
      if caller_binding
        return caller_binding.receiver.instance_variable_get(@value) if @value.start_with?('@')
        return caller_binding.receiver.send(@value.to_sym) if caller_binding.receiver.respond_to?(@value.to_sym)
      end

      ERB::Util.html_escape(@value)
    rescue StandardError => e
      value
    end
  end
end
