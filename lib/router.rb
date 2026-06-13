# frozen_string_literal: true

class Router < Roda
  def self.root = File.realpath File.join(__dir__, "..")

  plugin :public, root: File.join(root, "public")

  route do |r|
    r.root do
      response["content-type"] = "text/html"
      File.read(File.join(self.class.root, "public", "index.html"))
    end

    r.on "ri" do
      response["content-type"] = "application/json"
      r.get "index" do
        ri.index.to_json
      end

      r.get "search" do
        ri.search(r.params["q"]).to_json
      end
    end

    r.public
  end

  ##
  # @param [String] query
  # @return [String]
  def ri
    @ri ||= RI.new("ri")
  end
end
