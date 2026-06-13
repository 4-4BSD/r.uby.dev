# frozen_string_literal: true

class Find
  ##
  # @param [String] root
  # @return [Find]
  def initialize(root)
    @root = root
    @command = Command.new("find")
  end

  ##
  # @return [Hash]
  def index
    Dir.chdir @root do
      cmd = command
        .dup
        .argv(".")
        .argv("-type", "f")
        {ok: cmd.success?, stdout: cmd.stdout, stderr: cmd.stderr}
    end
  end

  private

  attr_reader :root, :command
end