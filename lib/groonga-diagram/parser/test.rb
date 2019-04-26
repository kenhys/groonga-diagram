module GroongaDiagram
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
