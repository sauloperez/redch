require 'hashr'

class Redch::Config
  def self.load
    yaml = YAML::load_file(File.open(filename, "r"))
    Hashr.new(yaml)
  rescue Errno::ENOENT
    raise StandardError.new
  end

  def self.save(config)
    hash = config.to_hash
    File.open(filename, 'w') { |f| f.write(hash.to_yaml) }
  end

  def self.filename
    @filename ||= File.expand_path('~/.redch.yml')
  end
end
