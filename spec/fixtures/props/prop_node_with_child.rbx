# frozen_string_literal: true

require 'lownode'

module RBX
  class PropNodeWithChild < LowNode
    def initialize
      @ivar = 'Parent Variable'
    end

    def render
      <html><{ PropNodeVar var=@ivar }></html>
    end

    # Usuallly a low node instance calls an antlers node, passing in the instance's binding.
    # But in this unit test we call an antlers node directly and supply it our mock binding.
    def instance_binding = binding
  end
end
