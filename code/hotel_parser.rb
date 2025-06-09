require 'yaml'

class HotelParser  
  # Parse the given YAML file and return a wrapped object
  #
  # @param filename [String] path to a YAML file
  # @return [YamlNode] the root of the parsed structure
  def self.parse(filename)
    raw_data = YAML.load_file(filename)

    unless raw_data.is_a?(Hash)
      raise ArgumentError, "Top-level YAML structure must be a Hash"
    end

    return YamlNode.new(raw_data)

  rescue Errno::ENOENT
    raise "File not found: #{filename}"
  rescue Psych::SyntaxError => e
    raise "Invalid YAML syntax: #{e.message}"
  end
end

# Proxy class to access nested Hash/Array data
class YamlNode
  def initialize(raw_obj)
    @obj = {}

    raw_obj.each do |key, value|
      @obj[key.to_s] = case value
      when Hash
        YamlNode.new(value)
      when Array
        # If it’s an Array, convert any Hash elements inside it
        value.map { |elem| elem.is_a?(Hash) ? YamlNode.new(elem) : elem }
      else
        value
      end
    end
  end

  # Method to handle [] like operator call on the object
  def [](key)
    @obj[key.to_s]
  end

  # Catch any unknown method calls for handling . method call on the object
  def method_missing(method_name, *args)
    key = method_name.to_s

    if @obj.key?(key)
      @obj[key]
    else
      super
    end
  end

  # Keep `respond_to?` method calls relevant to dynamic methods
  def respond_to_missing?(method_name)
    @obj.key?(method_name.to_s) || super
  end
end
