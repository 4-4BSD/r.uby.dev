# frozen_string_literal: true

class Router < Roda
  def self.root = File.realpath File.join(__dir__, "..")

  plugin :json
  plugin :render

  route do |r|
    r.root do
      response["content-type"] = "text/html"
      File.read(File.join(self.class.root, "public", "index.html"))
    end

    r.on "resume" do
      r.get(true) { resume! }
      r.root { resume! }
      r.get("index.html") { resume! }
    end

    r.on "api", "guides" do
      r.get "search" do
        rg(guides).search(r.params["q"])
      end

      r.get "index" do
        find(guides).index("*.md")
      end

      r.get "read" do
        path = File.expand_path(r.params["q"], "/")
        file = File.extname(path) == ".md" ? path : "#{path}.md"
        {ok: true, contents: File.read(File.join(guides, file))}
      rescue
        {ok: false, contents: ""}
      end
    end

    r.on "api", "mrbgems" do
      r.get "search" do
        find(mrbgems).search(r.params["q"])
      end

      r.get "index" do
        find(mrbgems).index("*.gem")
      end

      r.get "read" do
        path = File.expand_path(r.params["q"], "/")
        file = File.extname(path) == ".gem" ? path : "#{path}.gem"
        {ok: true, contents: File.read(File.join(mrbgems, file))}
      rescue
        {ok: false, contents: ""}
      end
    end

    r.on "api", "mruby" do
      r.get "search" do
        rg(src).search(r.params["q"])
      end

      r.get "index" do
        find(src).index
      end

      r.get "read" do
        path = File.expand_path(r.params["q"], "/")
        file = File.join(src, path)
        {ok: true, contents: File.read(file)}
      rescue
        {ok: false, contents: ""}
      end
    end
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
  def mrbgems
    ENV["MRBGEMS"] || File.join(root, "../mgem-list")
  end

  ##
  # @return [String]
  def mruby
    ENV["MRUBY"] || File.join(root, "../mruby")
  end

  ##
  # @return [String]
  def root
    @root ||= File.realpath File.join(__dir__, "..")
  end

  ##
  # @return [String]
  def guides
    File.join(mruby, "doc", "guides")
  end

  ##
  # @return [String]
  def src
    File.join(mruby, "src")
  end

  def resume!
    response["content-type"] = "text/html"
    view("resume", engine: "md", layout: "resume")
  end
end
