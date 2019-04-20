# frozen_string_literal: true

require 'thor'

module GroongaDiagram
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'groonga-diagram version'
    def version
      require_relative 'version'
      puts "v#{GroongaDiagram::VERSION}"
    end
    map %w(--version -v) => :version

      desc 'parse [FORMAT]', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def parse(format = nil)
        if options[:help]
          invoke :help, ['parse']
        else
          require_relative 'commands/parse'
          Groonga::Diagram::Commands::Parse.new(format, options).execute
        end
      end
  end
end
