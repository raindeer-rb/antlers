# frozen_string_literal: true

require_relative 'lexer'
require_relative 'parser'

module Antlers
  class << self
    def parse(template)
      return template unless template.include?('<{') || template.include?('{')

      lexemes = Lexer.new.parse(template)
      Parser.parse(lexemes)
    end

    def render(root_node, caller_binding: nil)
      root_node.render(caller_binding:)
    end
  end
end
