# frozen_string_literal: true

require_relative '../command'
require_relative '../parser'

module GroongaDiagram
  module Commands
    class Parse < GroongaDiagram::Command
      def initialize(files, options)
        @files = files
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        # Command logic goes here ...
        @files.each do |file|
          options = {
            :format => "test"
          }
          if file.end_with?(".expected")
            options[:format] = "expected"
          end
          parser = ::GroongaDiagram::Parser.new(options)
          open(file) do |io|
            parser.parse(io.read)
          end
        end
      end
    end
  end
end
