def fixture(file : String) : IO
  path = File.expand_path(File.join("./spec/fixtures", file))

  File.exists?(path) ||
    raise Exception.new(%(Fixture "#{path}" does not exist.))

  File.open(path)
end

def fixture_string(file : String) : String
  fixture(file).gets_to_end
end
