# frozen_string_literal: true

require_relative '../lexemes/var_lexeme'

module Antlers
  class LexerError < StandardError; end

  class Lexer
    def initialize(lexeme_types:)
      @lexeme_types = lexeme_types.to_a
      @var_lexeme = @lexeme_types.find { it == VarLexeme }

      @delimiters = ['<{', '}>']
      @delimiters = [*@delimiters, '{', '}'] if @var_lexeme

      @keywords = @lexeme_types.flat_map { |lexeme| lexeme.const_get(:KEYWORDS) }
      @cursor = 0
    end

    def parse(template:)
      @cursor = 0
      sequence = []

      # Split on delimiters and retain capture groups.
      segments = template.split(/(#{Regexp.union(@delimiters)})/).map(&:strip)

      until segments[@cursor].nil?
        if (segment = antlers_segment(segments:))
          sequence << antlers_lexeme(segment:, segments:)
          # Skipping: ['{', 'expression', '}']
          # Skipping: ['<{', 'name + props + keywords', '}>']
          @cursor += 3
        else
          segment = segments[@cursor]
          sequence << segment unless segment.empty?
          @cursor += 1
        end
      end

      sequence
    end

    private

    def antlers_segment(segments:)
      next_segment = segments[@cursor + 1]
      return nil unless next_segment && (segments[@cursor] == '<{' || brackets?(segments:))

      next_segment
    end

    def antlers_lexeme(segment:, segments:)
      name, props, keywords = parse_antlers_segment(segment:)

      return @var_lexeme.lexeme(segment:, raw: false) if @var_lexeme && brackets?(segments:)

      lexeme = @lexeme_types.find { it.match?(name:, keywords:) }
      return lexeme.lexeme(name:, props:, keywords:) if lexeme

      return @var_lexeme.lexeme(segment:, raw: true) if @var_lexeme && deerheads?(segments:)

      raise LexerError, "Unrecognised syntax: '#{segment}'"
    end

    def parse_antlers_segment(segment:)
      name_and_props, *keywords = segment.split(/(#{Regexp.union(@keywords)})/)
      name, *props = name_and_props.split(' ')
      [name, props, parse_keywords(keywords:)]
    end

    def parse_keywords(keywords:)
      key_values = {}

      while (keyword = keywords.shift)
        keyword.strip!
        value = keyword.end_with?(':') && value?(keywords.first) ? keywords.shift.strip : nil
        key_values[keyword] = value
      end

      key_values
    end

    def value?(string)
      # Support keywords without a value like "<{ form: }>" whose value will become an empty string.
      string = string.to_s.strip
      !string.empty? && !(string.start_with?(':') || string.end_with?(':'))
    end

    def brackets?(segments:)
      first, _, last = segments[@cursor..@cursor + 3].map(&:strip)
      first == '{' && last == '}'
    end

    def deerheads?(segments:)
      first, _, last = segments[@cursor..@cursor + 3].map(&:strip)
      first == '<{' && last == '}>'
    end
  end
end
