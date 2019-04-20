require "groonga/command/parser"
require "tty-table"

module GroongaDiagram
  class Parser
    def initialize(options={})
      @options = options
      case @options[:format]
      when "test"
        @parser = GrntestParser.new
      when "expected"
        @parser = GrntestExpectedParser.new
      else
        raise StandardError
      end
    end

    def parse(input)
      @parser.parse(input)
    end

    class GrntestExpectedParser < self
      def initialize
      end

      def parse
      end
    end

    class GrntestParser < self
      def initialize
        @parser = Groonga::Command::Parser.new
      end

      def parse(input)
        @parser.on_command do |command|
          #p command
        end
        @parser.on_load_start do |command|
          @data = []
          @columns = []
        end
        @parser.on_load_columns do |command, columns|
          p columns
        end
        @parser.on_load_value do |command, value|
          value.keys.each do |column|
            unless @columns.include?(column)
              @columns << column
            end
          end
          @data << value
        end
        @parser.on_load_complete do |command|
          puts command.arguments[:table]
          rows = []
          @data.each do |data|
            row = []
            @columns.each do |column|
              if data.has_key?(column)
                row << data[column]
              else
                row << "-"
              end
            end
            rows << row
          end
          table = TTY::Table.new header: @columns, rows: rows
          renderer = TTY::Table::Renderer::Unicode.new(table)
          puts renderer.render
        end
        input.each_line do |line|
          @parser << line
        end
        @parser.finish
      end
    end
  end
end
