# frozen_string_literal: true

require "rack/files"

public_root = File.expand_path("public", __dir__)
files = Rack::Files.new(public_root)

run lambda { |env|
  env["PATH_INFO"] = "/index.html" if env["PATH_INFO"] == "/"
  files.call(env)
}
