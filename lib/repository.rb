# frozen_string_literal: true

class Repository
  ##
  # @return [String]
  def self.path
    File.realpath(ENV["DOC_REPO"] || "../ruby-doc")
  end

  ##
  # @return [String]
  attr_reader :path

  ##
  # @return [String]
  attr_reader :locale

  ##
  # @return [Repository]
  def initialize(locale: "en")
    @path = self.class.path
    @locale = locale
  end

  ##
  # @return [Array<Book>]
  def books
    Dir[File.join(path, "documentation", "content", locale, "books", "*")].filter_map do
      next unless File.directory?(_1)
      Book.new(self, _1)
    end
  end
end
