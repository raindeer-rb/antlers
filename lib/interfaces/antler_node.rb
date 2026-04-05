# frozen_string_literal: true

module Antlers
  class AntlerNode
    attr_reader :name

    def initialize(name:)
      @name = name
    end

    def render(current_binding: nil, parent_binding: nil, namespace: nil)
      raise NotImplementedError
    end

    # Consider instance a value object on comparison.
    def ==(other) = other.class == self.class
    def eql?(other) = self == other
    def hash = [self.class].hash
  end
end
