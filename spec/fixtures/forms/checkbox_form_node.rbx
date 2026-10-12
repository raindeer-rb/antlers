# frozen_string_literal: true

require 'lownode'

module RBX
  class CheckboxFormNode < LowNode
    def render
      <{ form: method: 'POST' }>
        <{ label: 'Test Label' }>
        <{ checkbox: 'Enabled' }>
      <{ :form }>
    end
  end
end
