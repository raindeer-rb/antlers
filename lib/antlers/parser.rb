# frozen_string_literal: true

module Antlers
  class Parser
    class ParserError < StandardError; end

    def initialize(node_types:, namespace: nil)
      @node_types = node_types.to_a
      @namespace = namespace
      @template = nil
    end

    def parse(sequence:, template: nil, id: :root_node)
      @template = template

      branch(node: RootNode.new(name: id), sequence:)
    end

    def branch(node:, sequence:)
      until sequence.empty?
        segment = sequence.shift

        child_class = @node_types.find { |n| n.match?(segment:) }
        raise(ParserError, "No node matches #{segment}") unless child_class

        child = child_class.build(segment:, namespace: @namespace, template: @template)
        node.children << child

        if (end_key = child_class::END_KEY)
          sub_branch(node: child, sequence:, end_key:, end_name: child.end_name)
        end
      end

      node
    end

    def sub_branch(node:, sequence:, end_key:, end_name: nil)
      sub_sequence = []

      until sequence.first.is_a?(Hash) && sequence.first[end_key] == end_name
        raise ParserError, "Missing end tag for #{node.class}" if sequence.empty?

        sub_sequence << sequence.shift
      end

      # Remove the end tag we just stopped before.
      sequence.shift

      branch(node:, sequence: sub_sequence)
    end
  end
end
