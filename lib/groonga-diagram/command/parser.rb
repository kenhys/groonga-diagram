require "optparse"

require "groonga-diagram/version"
require "groonga-diagram/parser/test"
require "groonga-diagram/parser/expected"

module GroongaDiagram
  module Command
    class Parser
      def initialize(options={})
        @output = options[:output] || $stdout
      end

      def run(command_line)
        @options = {}
        @options[:format] = "test"

        parser = OptionParser.new
        parser.banner += " PATH1 PATH2 ..."
        parser.version = VERSION

        supported_formats = ["test", "expected"]
        parser.on("-f", "--format=FORMAT",
                  supported_formats,
                  "Parse specified files as FORMAT format",
                  "supported formats: [#{supported_formats.join(', ')}] (#{@options[:format]})") do |format|
          @options[:format] = format
        end

        paths = parser.parse!(command_line)
        paths.each do |path|
          File.open(path) do |file|
            case @options[:format]
            when "test"
              @parser = GrntestParser.new(output: @output)
            when "expected"
              @parser = GrntestExpectedParser.new(output: @output)
            else
              raise StandardError
            end
            @parser.parse(file.read)
          end
        end
        true
      end
    end
  end
end
