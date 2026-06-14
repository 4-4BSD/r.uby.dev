# frozen_string_literal: true

class RG
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
    Dir.chdir(root) do
      cmd = command.dup.argv("-e", q, "-F", "--context", 5.to_s)
      {ok: cmd.success?, stdout: cmd.stdout, stderr: cmd.stderr}
    end
  end

  private

  attr_reader :command, :root
end
