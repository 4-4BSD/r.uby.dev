# frozen_string_literal: true

class Router < Roda
  def self.root = File.realpath File.join(__dir__, "..")

  plugin :public, root: File.join(root, "public")

  route do |r|
    r.root do
      response["content-type"] = "text/html"
      File.read(File.join(self.class.root, "public", "index.html"))
    end

    r.on "mruby" do
      response["content-type"] = "application/json"
      r.get "search" do
        rg("../mruby/src").search(r.params["q"])
      end
    end

    r.public
  end

  ##
  # @return [RG]
  def rg(path)
    @rg ||= RG.new(path)
  end
end
