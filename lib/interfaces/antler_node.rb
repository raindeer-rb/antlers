# frozen_string_literal: true

module Antlers
  class AntlerNode
    attr_reader :name

    DEF_KEY = nil
    END_KEY = nil

    def initialize(name:)
      @name = name
    end

    def render(current_binding: nil, parent_binding: nil, slot_node: nil, namespace: nil, metadata: {})
      raise NotImplementedError
    end

    def end_name
      'level_1'
    end

    class << self
      def match?(segment:)
        raise NotImplementedError
      end

      def build(segment:, namespace:)
        raise NotImplementedError
      end
    end

    # Compare instance as a value object.
    def ==(other) = other.class == self.class
    def eql?(other) = self == other
    def hash = [self.class].hash
  end
end
