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
  end
end
