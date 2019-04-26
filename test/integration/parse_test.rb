require 'test_helper'
require 'groonga-diagram/commands/parse'
require 'groonga-diagram/parser'

class GroongaDiagram::Commands::ParseTest < Test::Unit::TestCase
  def test_executes_groonga_diagram_help_parse_command_successfully
    output = `groonga-diagram help parse`
    expected_output = <<-OUT
Usage:
  groonga-diagram parse FILES

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    assert_equal expected_output, output
  end
end
