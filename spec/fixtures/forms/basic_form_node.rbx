# frozen_string_literal: true

require 'lownode'

module RBX
  class BasicFormNode < LowNode
    def render
      <{ form: '/submit' }>
        <button>Submit</button>
      <{ :form }>
    end
  end
end
