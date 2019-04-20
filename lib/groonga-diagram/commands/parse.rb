# frozen_string_literal: true

require_relative '../command'

module GroongaDiagram
  module Commands
    class Parse < GroongaDiagram::Command
      def initialize(files, options)
        @files = files
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        # Command logic goes here ...
        p @files
      end
    end
  end
end
