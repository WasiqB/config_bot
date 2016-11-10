require 'thor'
require 'yaml'

module ConfigBot
  class Bot < Thor
    class_option :verbose, :type => :boolean, :aliases => %w{-v --verbose}

    desc "generate [NAME]", "Name of config file."
    map %w[g --gen] => :generate
    method_option :path, :aliases => "-p", :desc => "Path for the config file."
    method_option :config, :aliases => "-c", :desc => "Path for the questionare file."
    def generate name
      puts "Name = #{name}"
      puts "Generate Options: #{options.inspect}" if options
    end

    desc "new", "Creates new questionare file for our bot."
    method_option :name, :aliases => '-n', :desc => "Name for the file."
    method_option :path, :aliases => '-p', :desc => "Path for the file."
    def new
      puts "New Options: #{options.inspect}" if options
    end

    desc 'version', 'Display version'
    map %w[-v --version] => :version
    def version
      say "config_bot #{VERSION}"
    end
  end

  # if File.exist? path
  #   yaml = YAML.load_file path
  #   my_bot = ConfigBot.new yaml["name"]
  #   my_bot.load_questions yaml
  #   puts my_bot.to_hash.inspect
  # else
  #   error "File not found!"
  # end
end
