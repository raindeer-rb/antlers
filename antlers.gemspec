# frozen_string_literal: true

require_relative 'lib/antlers/version'

Gem::Specification.new do |spec|
  spec.name = 'antlers'
  spec.version = Antlers::VERSION
  spec.authors = ['maedi']
  spec.email = ['maediprichard@gmail.com']

  spec.summary = 'Templating language inside HTML inside Ruby'
  spec.description = 'A templating language embedded within HTML that is itself embedded within Ruby/RBX'
  spec.homepage = 'https://github.com/raindeer-rb/antlers'
  spec.required_ruby_version = '>= 3.3.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/raindeer-rb/antlers/src/branch/main'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('lib/**/*')
  end

  spec.require_paths = ['lib']
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }

  spec.add_dependency 'erb'
  spec.add_dependency 'lowkey'
  spec.add_dependency 'plugs'
end
