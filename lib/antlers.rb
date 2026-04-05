# frozen_string_literal: true

require_relative 'lexer'
require_relative 'parser'

require 'low_event'

module Antlers
  class << self
    def parse(template)
      return template unless template.include?('<{') || template.include?('{')

      lexemes = Lexer.new.parse(template)
      Parser.parse(lexemes)
    end

    def render(ast:, current_binding:, parent_binding: nil, namespace: nil)
      ast.render(current_binding:, parent_binding:, namespace:)
    end
  end
end
