# frozen_string_literal: true

class Router < Roda
  def self.root = File.realpath File.join(__dir__, "..")

  plugin :public, root: File.join(root, "public")

  route do |r|
    r.root do
      response["content-type"] = "text/html"
      File.read(File.join(self.class.root, "public", "index.html"))
    end

    r.public
  end
end
