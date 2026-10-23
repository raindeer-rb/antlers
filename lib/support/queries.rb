# frozen_string_literal: true

module Antlers
  module Queries
    class << self
      def user_defined_string?(string)
        wrapped_in?(string, "'") || wrapped_in?(string, '"')
      end

      # Strings like {"Hello"} and symbols like {:app_name} are translated, but not methods or instance variables.
      def translatable?(string)
        user_defined_string?(string) || string.start_with?(':')
      end

      def wrapped_in?(string, delimeter)
        string[0] == delimeter && string[-1] == delimeter
      end
    end
  end
end
