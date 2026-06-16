# frozen_string_literal: true

module Clean
  ##
  # Remove internal paths
  # @param [String] str
  # @return [String]
  def clean(str)
    str.gsub("#{@root}/", "")
  end
end
