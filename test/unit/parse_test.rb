# coding: utf-8
require 'test_helper'
require 'groonga-diagram/commands/parse'

class GroongaDiagram::Commands::ParseTest < Test::Unit::TestCase
  def test_executes_parse_command_successfully
    output = StringIO.new
    format = nil
    files = nil
    options = {}
    command = GroongaDiagram::Commands::Parse.new(format, files, options)

    command.execute(output: output)

    assert_equal "OK\n", output.string
  end

  class GrntestParserTest < self

    def test_load_table
      path = fixture_path(["load.test"])
      open(path) do |file|
        output = StringIO.new
        parser = GroongaDiagram::Parser::GrntestParser.new({:output => output})
        parser.parse(file.read)
        expected = <<-OUTPUT
Site
┌───────────────────┬───────────┐
│_key               │title      │
├───────────────────┼───────────┤
│http://example.org/│example org│
└───────────────────┴───────────┘
        OUTPUT
        assert_equal(expected, output.string)
      end
    end
  end

  class GrntestExpectedParserTest < self
  end
end
