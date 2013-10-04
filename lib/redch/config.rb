require 'hashr'

class Redch::Config
  def self.load
    Hashr.new YAML.load(File.open(filename, "r"))
  end

  def self.save(config)
    File.open(filename, 'w') { |f| f.write(config.to_hash.to_yaml) }
  end

  protected
  def self.filename
    @filename ||= File.expand_path('.redch.yml')    
  end
end