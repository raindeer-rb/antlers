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

    # TODO: Pass in and evaluate props.
    def render(antlers_node, props:)
      antlers_node.render
    end
  end
end
