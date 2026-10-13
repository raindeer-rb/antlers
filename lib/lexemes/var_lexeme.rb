# frozen_string_literal: true

require_relative '../interfaces/lexeme'
require_relative '../support/queries'

module Antlers
  module VarLexeme
    include Lexeme
    extend Queries
    extend self

    # Variables are special and are matched by the lexer in a hard-coded fashion.
    def match?(**)
      false
    end

    def lexeme(segment:, raw:, **)
      return { raw_var: segment } if raw

      { var: segment }
    end
  end
end
