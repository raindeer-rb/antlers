# frozen_string_literal: true

module Antlers
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
          # Skipping: ['{', '@ivar', '}']
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
      return nil unless next_segment && (segments[@cursor] == '<{' || ivar?(segments:))

      next_segment
    end

    def antlers_lexeme(antlers_segment:, segments:)
      return ivar(antlers_segment:) if ivar?(segments:)

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

    def ivar?(segments:)
      first, second, third = segments[@cursor..@cursor + 3].map(&:strip)
      first == '{' && second&.start_with?('@') && third == '}'
    end

    def slot?(name)
      name.start_with?(':') || name.end_with?(':')
    end

    def prop?(name)
      [*'A'..'Z'].include?(name[0])
    end

    def ivar(antlers_segment:)
      { ivar: antlers_segment.delete_prefix('@') }
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
