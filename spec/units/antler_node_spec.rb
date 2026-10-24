# frozen_string_literal: true

require 'lowevent'
require_relative '../../lib/interfaces/antler_node'

RSpec.describe Antlers::AntlerNode do
  subject(:node) { described_class.new(name: :node) }

  describe '#possible_render_event' do
    it 'is a render event with the props when lowevent is loaded' do
      event = node.possible_render_event(props: { limit: 3 })

      expect(event).to be_a(Low::Events::RenderEvent)
      expect([event.action, event.props]).to eq([:render, { limit: 3 }])
    end

    it 'has the params of the parent event' do
      event = Struct.new(:params).new({ id: '1' })
      parent_binding = binding

      expect(node.possible_render_event(props: {}, current_binding: parent_binding).params).to eq({ id: '1' })
    end

    it 'has empty params when the parent event has none' do
      event = Struct.new(:params).new(nil)

      expect(node.possible_render_event(props: {}, current_binding: binding).params).to eq({})
      expect(node.possible_render_event(props: {}).params).to eq({})
    end

    it 'is nil without lowevent' do
      hide_const('Low::Events::RenderEvent')

      expect(node.possible_render_event(props: {})).to be_nil
    end
  end
end
