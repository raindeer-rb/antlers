# frozen_string_literal: true

module Antlers
  class Lexer
    def initialize
      @delimiters = ['<{', '}>', '{', '}']
      @keywords = ['if:', 'for:', 'in:']
      @cursor = 0
    end

    def parse(template)
      @cursor = 0
      sequence = []
      segments = template.split(/(#{Regexp.union(@delimiters)})/) # Split on delimiters and retain capture groups.

      until segments[@cursor].nil?
        segment = segments[@cursor] # Save segment as a precaution, antlers_segment() should not increment cursor if no match.
        sequence << (antlers_segment(segments) || static_segment(segment) || next)
      end

      sequence
    end

    private

    def static_segment(segment)
      @cursor += 1
      segment.strip unless segment.strip.empty?
    end

    def antlers_segment(segments)
      segment = segments[@cursor].strip
      next_segment = segments[@cursor + 1]&.strip

      return unless next_segment

      if node?(segment, next_segment)
        left_segment, *_keywords = next_segment.split(/(#{Regexp.union(@keywords)})/)
        name, *props = left_segment.split(' ')

        @cursor += 3 # Skipping: ['<{', 'name + props + keywords', '}>']
        return { name:, props: props(props) }
      end

      if ivar?(segments)
        @cursor += 3 # Skipping: ['{', '@var', '}']
        return { ivar: next_segment.delete_prefix('@') }
      end

      nil
    end

    def node?(segment, next_segment)
      segment == '<{' && next_segment && [*'A'..'Z'].include?(next_segment[0])
    end

    def ivar?(segments)
      first, second, third = segments[@cursor..@cursor + 3].map(&:strip)
      first == '{' && second&.start_with?('@') && third == '}'
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
