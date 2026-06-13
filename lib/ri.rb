# frozen_string_literal: true

class RI
  ##
  # @param [String] path
  # @return [RI]
  def initialize(path)
    @command = Command.new(path)
  end

  ##
  # @param [String] q
  # @return [Hash]
  def search(q)
    cmd = command
      .dup
      .argv("-T")
      .argv("-f", "markdown")
      .argv(q)
    {ok: cmd.success?, stdout: cmd.stdout, stderr: cmd.stderr}
  end

  def index
    cmd = command.dup.argv("-l")
    {ok: cmd.success?, stdout: cmd.stdout, stderr: cmd.stderr}
  end

  private

  attr_reader :command
end