# frozen_string_literal: true

module Antlers
  module Namespace
    def class_constant(namespace:, name:)
      return Object.const_get(name) if name.start_with?('::')

      class_from_namespace(namespace:, name:)
    end

    # Nil when the class isn't defined in the namespace or any of its parents.
    def class_from_namespace(namespace:, name:)
      namespace_with_name = [*namespace, name].join('::')
      return Object.const_get(namespace_with_name) if Object.const_defined?(namespace_with_name)
      return nil if namespace.empty?

      class_from_namespace(namespace: namespace[0...-1], name:)
    end
  end
end
