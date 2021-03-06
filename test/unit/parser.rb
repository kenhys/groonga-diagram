# coding: utf-8

require 'test_helper'
require 'groonga-diagram/parser'

class GrntestParserTest < Test::Unit::TestCase
  def test_load_table
    path = fixture_path(["load.test"])
    File.open(path) do |file|
      output = StringIO.new
      parser = GroongaDiagram::Parser::GrntestParser.new(output: output)
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

  def test_continuous_line
    path = fixture_path(["continuous_line.test"])
    File.open(path) do |file|
      output = StringIO.new
      parser = GroongaDiagram::Parser::GrntestParser.new(output: output)
      parser.parse(file.read)
      expected = <<-OUTPUT
logical_select \\
  --logical_table \"Logs\" \\
  --shard_key \"timestamp\" \\
  --sort_keys \"timestamp\"
      OUTPUT
      assert_equal(expected, output.string)
    end
  end
end

class GrntestExpectedParserTest < Test::Unit::TestCase
  def test_load
    path = fixture_path(["load.expected"])
    File.open(path) do |file|
      output = StringIO.new
      parser = GroongaDiagram::Parser::GrntestExpectedParser.new(output: output)
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

  def test_load_vector
    path = fixture_path(["load_vector.expected"])
    File.open(path) do |file|
      output = StringIO.new
      parser = GroongaDiagram::Parser::GrntestExpectedParser.new(output: output)
      parser.parse(file.read)
      expected = <<-OUTPUT
Memos
┌───────────────┬────────────────────────────────────┐
│_key           │tags                                │
├───────────────┼────────────────────────────────────┤
│Groonga is fast│[{\"groonga\"=>100}, {\"mroonga\"=>200}]│
└───────────────┴────────────────────────────────────┘
        OUTPUT
      assert_equal(expected, output.string)
    end
  end

  def test_logical_select
    path = fixture_path(["logical_select.expected"])
    File.open(path) do |file|
      output = StringIO.new
      parser = GroongaDiagram::Parser::GrntestExpectedParser.new(output: output)
      parser.parse(file.read)
      expected = <<-OUTPUT
logical_select \\
  --logical_table \"Logs\" \\
  --shard_key \"timestamp\" \\
  --sort_keys \"timestamp\"
┌───┬───────────────────┬────────────┐
│_id│memo               │timestamp   │
├───┼───────────────────┼────────────┤
│2  │2015-02-03 12:49:00│1422935340.0│
│1  │2015-02-03 23:59:59│1422975599.0│
│1  │2015-02-04 00:00:00│1422975600.0│
└───┴───────────────────┴────────────┘
      OUTPUT
      assert_equal(expected, output.string)
    end
  end
end
