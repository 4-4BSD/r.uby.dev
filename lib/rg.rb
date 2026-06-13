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
  # @return [Hash]
  def search(q)
    Dir.chdir(root) do
      cmd = command.dup.argv("-e", q, "-F")
      JSON.dump({ok: cmd.success?, stdout: cmd.stdout, stderr: cmd.stderr})
    end
  end

  private

  attr_reader :command, :root
end
