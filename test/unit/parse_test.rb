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
end
