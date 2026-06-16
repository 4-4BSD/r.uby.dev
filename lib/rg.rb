# frozen_string_literal: true

class RG
  include Clean

  ##
  # @param [String] root
  # @return [RG]
  def initialize(root)
    @root = root
    @command = Command.new("rg")
  end

  ##
  # @param [String] q
  # @param [Integer] context
  # @return [Hash]
  def search(q, context: 5)
    cmd = command
      .dup
      .argv("-e", q)
      .argv("--context", 5.to_s)
      .argv("-F")
      .argv(@root)
    {ok: cmd.success?, stdout: clean(cmd.stdout), stderr: clean(cmd.stderr)}
  end

  private

  attr_reader :command, :root
end
