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
  def index(name = "*")
    Dir.chdir @root do
      cmd = command
        .dup
        .argv(".")
        .argv("-type", "f")
        .argv("-name", name)
        {ok: cmd.success?, stdout: cmd.stdout, stderr: cmd.stderr}
    end
  end

  ##
  # @return [Hash]
  def search(q)
    Dir.chdir root do
      cmd = command
        .dup
        .argv(".")
        .argv("-type", "f")
        .argv("-name", "*#{q}*")
        {ok: cmd.success?, stdout: cmd.stdout, stderr: cmd.stderr}
    end
  end

  private

  attr_reader :root, :command
end