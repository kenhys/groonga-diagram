require "groonga/command/parser"
require "groonga/command/format/command"
require "tty-table"
require "json"

require "groonga-diagram/parser/test"
require "groonga-diagram/parser/expected"

module GroongaDiagram
  module Parser
    class GrnParser
      def initialize(options={})
        @options = options
        @output = options[:output] || $stdout
        case @options[:format]
        when "test"
          @parser = GrntestParser.new({:output => @output})
        when "expected"
          @parser = GrntestExpectedParser.new({:output => @output})
        else
          raise StandardError
        end
      end

      def parse(input)
        @parser.parse(input)
      end

    end
  end
end
