# frozen_string_literal: true

module Antlers
  # Gives a method only the keywords it takes like initialize(limit:) and render(event:, slot:).
  # LowNode uses the Method Factory pattern but the *instance* methods behave as the actualy method definitions.
  module Keywords
    module_function

    # The keywords the method declares, or all of them when it takes **.
    def accepted(method, keywords)
      parameters = method.parameters
      return keywords if parameters.any? { |type, _| type == :keyrest }

      keywords.slice(*declared(parameters))
    end

    # Whether the method takes the keyword, by name or with **.
    def takes?(method, name)
      parameters = method.parameters
      parameters.any? { |type, _| type == :keyrest } || declared(parameters).include?(name)
    end

    def declared(parameters)
      parameters.filter_map { |type, name| name if %i[key keyreq].include?(type) }
    end
  end
end
