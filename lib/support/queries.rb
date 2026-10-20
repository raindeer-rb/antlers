# frozen_string_literal: true

module Antlers
  module Queries
    class << self
      def user_defined_string?(string)
        wrapped_in?(string, "'") || wrapped_in?(string, '"')
      end

      def wrapped_in?(string, delimeter)
        string[0] == delimeter && string[-1] == delimeter
      end
    end
  end
end
