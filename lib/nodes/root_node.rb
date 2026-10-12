# frozen_string_literal: true

require_relative '../interfaces/branch_node'

module Antlers
  class RootNode < BranchNode
    def initialize(name: :root_node, children: [])
      super(name:, children:)
    end

    class << self
      def match?(**)
        false
      end

      def build(**)
        new
      end
    end
  end
end
