# frozen_string_literal: true

require "roda"
require "json"
require "test/cmd"

class Command < Test::Cmd
end

require_relative "find"
require_relative "rg"
require_relative "router"
