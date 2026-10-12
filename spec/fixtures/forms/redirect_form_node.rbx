# frozen_string_literal: true

require 'lownode'

module RBX
  class RedirectFormNode < LowNode
    def render
      <{ form: 'action-path' redirect: 'redirect-path' }>
        <{ submit: 'Redirect Me' }>
      <{ :form }>
    end
  end
end
