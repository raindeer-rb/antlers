# frozen_string_literal: true

require_relative 'queries'

module Antlers
  extend Queries

  class LexerParseError < StandardError; end

  class Lexer
    def initialize
      @delimiters = ['<{', '}>', '{', '}']
      @keywords = ['if:', 'for:', 'in:']
      @cursor = 0
    end

    def parse(template)
      @cursor = 0
      sequence = []

      # Split on delimiters and retain capture groups.
      segments = template.split(/(#{Regexp.union(@delimiters)})/).map(&:strip)

      until segments[@cursor].nil?
        if (antlers_segment = antlers_segment(segments:))
          sequence << antlers_lexeme(antlers_segment:, segments:)
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
      return nil unless next_segment && (segments[@cursor] == '<{' || var?(segments:))

      next_segment
    end

    def antlers_lexeme(antlers_segment:, segments:)
      return var(antlers_segment:) if var?(segments:)

      name, props, _keywords = parse_segment(antlers_segment:)

      return slot(name:, props:) if slot?(name)
      return prop(name:, props:) if prop?(name)

      raise LexerParseError, "Couldn't parse antlers syntax: '#{antlers_segment}'"
    end

    def parse_segment(antlers_segment:)
      name_and_props, *keywords = antlers_segment.split(/(#{Regexp.union(@keywords)})/)
      name, *props = name_and_props.split(' ')

      [name, props, keywords]
    end

    def var?(segments:)
      first, middle, last = segments[@cursor..@cursor + 3].map(&:strip)
      first == '{' && last == '}'
    end

    def slot?(name)
      name.start_with?(':') || name.end_with?(':')
    end

    def prop?(name)
      [*'A'..'Z'].include?(name[0])
    end

    def var(antlers_segment:)
      # String is already interpolated or not depending on user input on the template layer, now we store it without those template quotes.
      if Queries.user_defined_string?(antlers_segment)
        antlers_segment = antlers_segment[1..-2]
      end

      { var: antlers_segment }
    end

    def slot(name:, props:)
      if name.end_with?(':')
        slot_def = { slot_def: name.delete_suffix(':') }
        slot_def[:props] = props(props) unless props.empty?
        return slot_def
      end

      { slot_end: name.delete_prefix(':') }
    end

    def prop(name:, props:)
      prop = { prop: name }
      prop[:props] = props(props) unless props.empty?
      prop
    end

    def props(props)
      odd_props = props.join(' ').split(/(=)|\s/)

      return {} unless odd_props.any?

      props = {}
      until odd_props.empty?
        prop = odd_props.shift
        value = nil

        if odd_props.first == '='
          odd_props.shift
          value = odd_props.shift
        end

        props[prop] = value
      end

      props
    end
  end
end
