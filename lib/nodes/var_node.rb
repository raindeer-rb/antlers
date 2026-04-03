# frozen_string_literal: true

require_relative '../interfaces/antler_node'

module Antlers
  class VarNode < AntlerNode
    def render
      'VARIABLE'
    end
  end
end
