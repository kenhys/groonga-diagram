require "groonga-diagram/parser/base"
require "groonga/command/parser"
require "tty-table"

module GroongaDiagram
  module Parser
    class GrntestExpectedParser < BaseParser
      def initialize(options={})
        @parser = Groonga::Command::Parser.new
        @output = options[:output] || $stdout
      end

      def parse(input)
        @parser.on_command do |command|
          if select?(command)
            formatter = Groonga::Command::Format::Command.new(command.command_name, command.arguments)
            @output.puts(formatter.command_line(pretty_print: true))
          end
        end
        @parser.on_load_start do
          @data = []
          @columns = []
        end
        @parser.on_load_columns do |_command, columns|
          @columns = columns
        end
        @parser.on_load_value do |_command, value|
          if value.empty?
            @columns << "_id"
            next
          end
          if value.is_a?(Array)
            row = {}
            @columns.each_with_index do |column, index|
              if value[index].size > 32
                row[column] = value[index][0, 32] + "..."
              else
                row[column] = value[index]
              end
            end
            @data << row
          else
            value.keys.each do |column|
              @columns << column unless @columns.include?(column)
            end
            @data << value
          end
        end
        @parser.on_load_complete do |command|
          @output.puts(command.arguments[:table])
          rows = []
          @data.each do |data|
            row = []
            @columns.each do |column|
              if data.key?(column)
                row << data[column].to_s
              else
                row << "-"
              end
            end
            rows << row
          end
          table = TTY::Table.new header: @columns, rows: rows
          renderer = TTY::Table::Renderer::Unicode.new(table)
          @output.puts(renderer.render)
        end
        in_response = false
        in_load = false
        response = ""
        input.each_line do |line|
          if line =~ /\A\[\[.+\]\]/
            parsed = parse_response(line)
            table = TTY::Table.new header: parsed[:header], rows: parsed[:rows]
            renderer = TTY::Table::Renderer::Unicode.new(table)
            @output.puts(renderer.render)
          elsif line.start_with?("[[")
          elsif line.start_with?("load")
            in_load = true
            @parser << line
          elsif line.start_with?("[")
            if in_load
              @parser << line
            else
              in_response = true
              response = "[\n"
            end
          elsif line.start_with?("]")
            if in_response
              response << "]"
              parsed = parse_response(response)
              table = TTY::Table.new header: parsed[:header], rows: parsed[:rows]
              renderer = TTY::Table::Renderer::Unicode.new(table)
              @output.puts(renderer.render)
            end
            if in_load
              @parser << line
              in_load = false
            end
            in_response = false if in_response
          else
            if in_response
              response << line
            else
              @parser << line
            end
          end
        end
        @parser.finish
      end

      def parse_response(response)
        headers = []
        rows = []
        json = JSON.parse(response)
        array = json[1][0]
        array.each do |entry|
          if entry.size == 1
          elsif entry[0].is_a?(Array)
            entry.each do |column|
              headers << column[0]
            end
          else
            row = []
            entry.each do |column|
              if column.is_a?(String) and column.size > 32
                row << column[0, 32] + "..."
              else
                row << column
              end
            end
            rows << row
          end
        end
        {
          header: headers,
          rows: rows
        }
      end
    end
  end
end
