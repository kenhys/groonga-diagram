# frozen_string_literal: true

require_relative '../command'

module GroongaDiagram
  module Commands
    class Parse < Groonga::Diagram::Command
      def initialize(format, options)
        @format = format
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        # Command logic goes here ...
        output.puts "OK"
      end
    end
  end
end
