# frozen_string_literal: true

class Book
  ##
  # @return [String]
  attr_reader :name

  ##
  # @return [String]
  attr_reader :path

  ##
  # @return [String]
  def self.database
    dir = File.realpath File.join(__dir__, "..", "share", "rubydoc")
    "sqlite://#{File.join(dir, "database.sqlite3")}"
  end

  ##
  # @param [Repository] repository
  # @param [String] path
  # @return [Book]
  def initialize(repository, path)
    @repository = repository
    @path = path
    @name ||= File.basename(path)
  end

  ##
  # @return [Array<Chapter>]
  def chapters
    Dir[File.join(path, "*")].filter_map do
      next unless File.directory?(_1)
      Chapter.new(self, _1)
    end
  end
end
