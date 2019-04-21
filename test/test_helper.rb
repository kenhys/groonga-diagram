def fixture_path(*elements)
  File.join(File.dirname(__FILE__), "fixtures", *elements)
end
