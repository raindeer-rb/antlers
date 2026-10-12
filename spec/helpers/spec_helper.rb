# frozen_string_literal: true

require 'dirload'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    # Large diff when expected objects don't match.
    expectations.max_formatted_output_length = 10_000
  end
end

class String
  # Delete whitespace at the start of a new line, then delete new lines.
  def squish
    gsub(/^\s*/, '').delete("\n")
  end
end
