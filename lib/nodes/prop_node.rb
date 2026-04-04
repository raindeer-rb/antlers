# frozen_string_literal: true

require_relative '../interfaces/antler_node'
require_relative '../interfaces/class_render'

module Antlers
  class PropNode < AntlerNode
    include ClassRender

    attr_accessor :props

    def initialize(name:, props: {})
      super(name:)

      @props = props
    end
  end
end
