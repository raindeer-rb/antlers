# frozen_string_literal: true

module Antlers
  module Props
    attr_accessor :props

    def initialize(name:, props: {}, **)
      super(name:, **)

      @props = props
    end
  end
end
