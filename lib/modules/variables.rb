# frozen_string_literal: true

require 'erb'
require 'lowkey'
require_relative '../support/queries'

module Antlers
  module Variables
    extend Queries

    # Evaluation limited to the following for security and to stop a templating language becoming a programming language.
    #  1. A value ('string', 3, 1.5, true, nil or :symbol)
    #  2. Invalid string ("Hi #{name}", 'it's', 'a' + 'b')
    #  3. An instance variable
    #  4. A method call/local variable
    #  5. A method chain
    def evaluate(value:, current_binding:, escape: true)
      result = result(value:, current_binding:)

      return ERB::Util.html_escape(result) if escape

      result
    end

    def result(value:, current_binding:)
      Lowkey::ValueParser.parse(value) do
        next value[1..-2] if Queries.user_defined_string?(value)
        next value unless current_binding

        variable(value:, current_binding:)
      end
    end

    private

    def variable(value:, current_binding:)
      name, *chain = value.split('.')

      result = method_var(name:, current_binding:)
      return method_chain(result:, chain:) if chain.count > 0

      result
    end

    def method_var(name:, current_binding:)
      return current_binding.receiver.instance_variable_get(name) if name.start_with?('@')
      return current_binding.local_variable_get(name) if current_binding.local_variable_defined?(name)
      return current_binding.receiver.send(name.to_sym) if current_binding.receiver.respond_to?(name.to_sym)

      nil
    end

    def method_chain(result:, chain:)
      chain.reduce(result) do |result, method_call|
        result&.send(method_call.to_sym)
      end
    end
  end
end
