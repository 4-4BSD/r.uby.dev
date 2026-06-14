# frozen_string_literal: true

require "rack/static"
require File.join(__dir__, "lib", "init")

use Rack::Static,
  root: File.expand_path("public", __dir__),
  urls: [""],
  index: "index.html",
  cascade: true

run Router
