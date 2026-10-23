# frozen_string_literal: true

module Antlers
  # Translates strings like {"Hello"} and symbols like {:app_name} into the current locale.
  # Top-level keys are "symbols" or a language code, mapping a source string to its translation:
  #   symbols:
  #     app_name: 'Raindeer'
  #   es:
  #     'Hello': 'Hola'
  module Translations
    SYMBOLS = 'symbols'

    module_function

    def load(translations)
      @translations = (translations || {}).to_h do |locale, mappings|
        [locale.to_s, (mappings || {}).to_h { |source, translation| [source.to_s, translation.to_s] }.freeze]
      end.freeze
    end

    def translations
      @translations ||= {}.freeze
    end

    def locales
      translations.keys - [SYMBOLS]
    end

    # Fiber storage is inherited by child fibers, so a locale set for a request applies to everything it renders.
    def locale
      Fiber[:antlers_locale]
    end

    def locale=(locale)
      Fiber[:antlers_locale] = locale&.to_s
    end

    def with_locale(locale)
      previous = self.locale
      self.locale = locale
      yield
    ensure
      self.locale = previous
    end

    # A string translates to the locale's mapping for it, or stays the same when there isn't one.
    # A symbol renders its value under "symbols", which is then translated like any other string.
    def translate(value, locale: self.locale)
      if value.is_a?(Symbol)
        name = value.to_s
        value = translations.dig(SYMBOLS, name) || name
      end

      return value unless value.is_a?(String) && locale

      translations.dig(locale.to_s, value) || value
    end
  end
end
