# frozen_string_literal: true

require_relative '../../lib/antlers'

RSpec.describe Antlers::Translations do
  subject(:translations) { described_class }

  before do
    translations.load({ symbols: { app_name: 'Raindeer' }, es: { 'Hello' => 'Hola', 'Raindeer' => 'Renos' } })
  end

  after { translations.load({}) }

  describe '.translate' do
    it 'keeps a string without a locale' do
      expect(translations.translate('Hello')).to eq('Hello')
    end

    it 'translates a string into the locale' do
      expect(translations.translate('Hello', locale: :es)).to eq('Hola')
    end

    it 'keeps a string the locale has no mapping for' do
      expect(translations.translate('Goodbye', locale: :es)).to eq('Goodbye')
    end

    it 'keeps a string in an unknown locale' do
      expect(translations.translate('Hello', locale: :fr)).to eq('Hello')
    end

    it 'renders a symbol with its value' do
      expect(translations.translate(:app_name)).to eq('Raindeer')
    end

    it 'translates a symbol value into the locale' do
      expect(translations.translate(:app_name, locale: 'es')).to eq('Renos')
    end

    it 'renders an undefined symbol as its name' do
      expect(translations.translate(:missing)).to eq('missing')
    end
  end

  describe '.with_locale' do
    it 'sets the locale for the block' do
      result = translations.with_locale(:es) { translations.translate('Hello') }

      expect(result).to eq('Hola')
      expect(translations.locale).to be_nil
    end

    it 'is inherited by child fibers' do
      result = translations.with_locale(:es) { Fiber.new { translations.translate('Hello') }.resume }

      expect(result).to eq('Hola')
    end
  end

  describe '.locales' do
    it 'lists language codes without symbols' do
      expect(translations.locales).to eq(['es'])
    end
  end

  describe 'rendering' do
    let(:binding_class) do
      Class.new do
        def greeting = 'Hello'
        def instance_binding = binding
      end
    end

    def render(template, current_binding: nil)
      Antlers.render(ast: Antlers.ast(template:), current_binding:)
    end

    it 'translates a string' do
      expect(translations.with_locale(:es) { render('<p>{"Hello"}</p>') }).to eq('<p>Hola</p>')
    end

    it 'translates a symbol' do
      expect(translations.with_locale(:es) { render('<p>{:app_name}</p>') }).to eq('<p>Renos</p>')
    end

    it 'escapes a translation' do
      translations.load({ es: { 'Hello' => '<b>Hola</b>' } })

      expect(translations.with_locale(:es) { render('<p>{"Hello"}</p>') }).to eq('<p>&lt;b&gt;Hola&lt;/b&gt;</p>')
    end

    it "doesn't translate the value of a method" do
      current_binding = binding_class.new.instance_binding

      expect(translations.with_locale(:es) { render('<p>{greeting}</p>', current_binding:) }).to eq('<p>Hello</p>')
    end
  end
end
