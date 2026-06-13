# frozen_string_literal: true

class Router < Roda
  def self.root = File.realpath File.join(__dir__, "..")

  plugin :public, root: File.join(root, "public")
  plugin :json

  route do |r|
    r.root do
      response["content-type"] = "text/html"
      File.read(File.join(self.class.root, "public", "index.html"))
    end

    r.on "mruby", "src" do
      r.get "search" do
        rg(src).search(r.params["q"])
      end

      r.get "index" do
        find(src).index
      end

      r.get "read" do
        Dir.chdir(src) do
          path = File.expand_path(r.params["q"], "/")
          file = File.join(Dir.getwd, path)
          {ok: true, contents: File.read(file)}
        rescue
          {ok: false, contents: ""}
        end
      end
    end

    r.public
  end

  ##
  # @return [RG]
  def rg(path)
    @rg ||= RG.new(path)
  end

  ##
  # @return [Find]
  def find(path)
    @find ||= Find.new(path)
  end

  ##
  # @return [String]
  def mruby
    ENV["MRUBY"] || "../mruby"
  end

  ##
  # @return [String]
  def src
    File.join(mruby, "src")
  end
end
