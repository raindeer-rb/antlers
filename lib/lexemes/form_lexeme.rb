# frozen_string_literal: true

require_relative '../interfaces/lexeme'

module Antlers
  module FormLexeme
    include Lexeme
    extend self

    KEYWORDS = ['form:', ':form'].freeze

    def match?(keywords:, **)
      KEYWORDS.include?(keywords.keys.first)
    end

    def lexeme(keywords:, **)
      return { form_def: keywords['form:'] } if keywords.key?('form:')

      { form_end: 'level_1' }
    end
  end
end
