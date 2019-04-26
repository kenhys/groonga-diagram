require 'test_helper'
require 'groonga-diagram/command/parser'

class CommandTest < Test::Unit::TestCase
  def test_usage
    output = `groonga-diagram -h`
    expected_output = <<-OUTPUT
Usage: groonga-diagram [options] PATH1 PATH2 ...
    -f, --format=FORMAT              Parse specified files as FORMAT format
                                     supported formats: [test, expected] (test)
    OUTPUT
    assert_equal expected_output, output
  end
end
