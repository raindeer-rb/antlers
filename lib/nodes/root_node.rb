# frozen_string_literal: true

require_relative '../interfaces/branch_node'

module Antlers
  class RootNode < BranchNode
    def initialize(name: :root_node, children: [])
      super(name:, children:)
    end
  end
end
