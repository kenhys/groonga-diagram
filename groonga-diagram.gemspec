
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "groonga-diagram/version"

Gem::Specification.new do |spec|
  spec.name          = "groonga-diagram"
  spec.license       = "LGPLv2.1+"
  spec.version       = GroongaDiagram::VERSION
  spec.authors       = ["Kentaro Hayashi"]
  spec.email         = ["kenhys@gmail.com"]

  spec.summary       = %q{Command line utility to visualize Groonga schema}
  spec.description   = %q{Command line utility to visualize Groonga schema into console friendly output}
  spec.homepage      = "https://github.com/kenhys/groonga-diagram"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/kenhys/groonga-diagram"
    spec.metadata["changelog_uri"] = "https://github.com/kenhys/groonga-diagram/blob/master/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "tty-table", "~> 0.10.0"
  spec.add_dependency "thor", "~> 0.20.0"
  spec.add_dependency "groonga-command-parser", "~> 1.1.4"
  spec.add_dependency "groonga-command", "~> 1.4.1"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "test-unit", "~> 3.3"
  spec.add_development_dependency "rubocop", "~> 0.82"
end
