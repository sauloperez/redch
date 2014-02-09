require 'hashr'

class Redch::Config
  FILE_PATH = '~/.redch.yml'

  def self.load
    hash = YAML::load_file(File.open(filename, "r"))
    Hashr.new(hash)
  rescue Errno::ENOENT
    raise StandardError.new
  end

  def self.save(config)
    hash = config.to_hash
    File.open(filename, 'w') { |f| f.write(hash.to_yaml) }
  end

  def self.filename
    @filename ||= File.expand_path(FILE_PATH)
  end
end
