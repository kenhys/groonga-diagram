require "groonga/command/parser"
require "groonga/command/format/command"
require "tty-table"
require "json"

module GroongaDiagram
  class Parser
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

    def select?(command)
      [
        "select",
        "logical_select"
      ].include?(command.command_name)
    end

    class GrntestExpectedParser < self
      def initialize(options={})
        @parser = Groonga::Command::Parser.new
        @output = options[:output] || $stdout
      end

      def parse(input)
        @parser.on_command do |command|
          if select?(command)
            formatter = Groonga::Command::Format::Command.new(command.command_name, command.arguments)
            @output.puts(formatter.command_line({:pretty_print => true}))
          end
        end
        @parser.on_load_start do |command|
          @data = []
          @columns = []
        end
        @parser.on_load_columns do |command, columns|
          @columns = columns
        end
        @parser.on_load_value do |command, value|
          if value.empty?
            @columns << "_id"
            next
          end
          if value.kind_of?(Array)
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
              unless @columns.include?(column)
                @columns << column
              end
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
              if data.has_key?(column)
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
          elsif line =~ /\A\[\[/
          elsif line =~ /\Aload/
            in_load = true
            @parser << line
          elsif line =~ /\A\[/
            if in_load
              @parser << line
            else
              in_response = true
              response = "[\n"
            end
          elsif line =~ /\A\]/
            if in_response
              response << "]"
              parsed = parse_response(response)
              table = TTY::Table.new header: parsed[:header], rows: parsed[:rows]
              renderer = TTY::Table::Renderer::Unicode.new(table)
              @output.puts(renderer.render)
            end
            if in_load
              @parser << line
            end
            in_load = false if in_load
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
          elsif entry[0].kind_of?(Array)
            entry.each do |column|
              headers << column[0]
            end
          else
            row = []
            entry.each do |column|
              if column.size > 32
                row << column[0, 32] + "..."
              else
                row << column
              end
            end
            rows << row
          end
        end
        {
          :header => headers,
          :rows => rows
        }
      end
    end

    class GrntestParser < self
      def initialize(options={})
        @parser = Groonga::Command::Parser.new
        @output = options[:output] || $stdout
      end

      def parse(input)
        @parser.on_command do |command|
          if select?(command)
            formatter = Groonga::Command::Format::Command.new(command.command_name,
                                                              command.arguments)
            @output.puts(formatter.command_line({:pretty_print => true}))
          end
        end
        @parser.on_load_start do |command|
          @data = []
          @columns = []
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
          @output.puts(command.arguments[:table])
          rows = []
          @data.each do |data|
            row = []
            @columns.each do |column|
              if data.has_key?(column)
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
        continuous_line = false
        buffer = ""
        input.each_line do |line|
          if line =~ /\\\n$/
            if continuous_line
              strip_line = line.sub(/\\\n$/, '')
              buffer << strip_line
            else
              strip_line = line.sub(/\\\n$/, '')
              buffer = strip_line
              continuous_line = true
            end
          else
            if continuous_line
              buffer << line
              @parser << buffer
              continuous_line = false
            else
              @parser << line
            end
          end
        end
        @parser.finish
      end
    end
  end
end
