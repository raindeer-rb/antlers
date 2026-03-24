# frozen_string_literal: true

require_relative '../interfaces/antler_node'

module Antlers
  attr_accessor :props

  class PropNode < AntlerNode
    def initialize(name:, props: [])
      super(name:)

      @props = props
    end
  end
end
