# frozen_string_literal: true

require_relative 'antler_node'

module Antlers
  class << self
    def parse(template)
      return template unless template.include?('<{') || template.include?('{')

      AntlerNode.new(template)
    end

    def render(antler_node); end
  end
end
