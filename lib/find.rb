# frozen_string_literal: true

class Find
  include Clean

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
    cmd = command
      .dup
      .argv(@root)
      .argv("-type", "f")
      .argv("-name", name)
    {ok: cmd.success?, stdout: indexify(clean(cmd.stdout)), stderr: clean(cmd.stderr)}
  end

  ##
  # @return [Hash]
  def search(q)
    cmd = command
      .dup
      .argv(@root)
      .argv("-type", "f")
      .argv("-name", "*#{q}*")
    {ok: cmd.success?, stdout: clean(cmd.stdout), stderr: clean(cmd.stderr)}
  end

  private

  def indexify(stream)
    stream.each_line.map do |line|
      line = line.chomp
      File.basename(line, File.extname(line))
    end.join("\n")
  end

  attr_reader :root, :command
end
