# frozen_string_literal: true

module Antlers
  class << self
    def parse(template)
      return template unless template.include?('<{') || template.include?('{')

      lexemes = Lexer.new.parse(template)
      Parser.parse(lexemes)
    end

    # TODO: Render the AST.
    def render(antler_node); end
  end
end
