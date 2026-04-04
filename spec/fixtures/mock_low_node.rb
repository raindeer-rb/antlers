# frozen_string_literal: true

class MockLowNode
  def initialize(event:) = self

  def render(event:, **props)
    raise NotImplementedError
  end

  def self.render(event:, **props)
    self.new(event:).render(event:, **props)
  end
end
