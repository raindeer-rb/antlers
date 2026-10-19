# frozen_string_literal: true

module Antlers
  module Queries
    class << self
      def user_defined_string?(string)
        wrapped_in?(string, "'") || wrapped_in?(string, '"')
      end

      # A number literal, like 3, -2 or 1.5, rather than a variable or method name.
      def number?(string)
        string.match?(/\A-?\d+(\.\d+)?\z/)
      end

      def number(string)
        string.include?('.') ? string.to_f : string.to_i
      end

      def wrapped_in?(string, delimeter)
        string[0] == delimeter && string[-1] == delimeter
      end
    end
  end
end
