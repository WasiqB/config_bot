require 'thor'
require 'yaml'
require_relative 'cli/generate'
require_relative "cli/new"

module ConfigBot
  class Bot < Thor
    class_option :verbose, :type => :boolean, :aliases => '-v'

    desc "generate [NAME]", "Name of config file to be created."
    map %w[g --gen] => :generate
    method_option :path, :aliases => "-p", :desc => "Path for the config file."
    method_option :config, :aliases => "-c", :desc => "Path for the questionare file."
    def generate name

    end

    desc "new", "Creates new questionare file for our bot."
    method_option :name, :aliases => '-n', :desc => "Name for the file."
    method_option :path, :aliases => '-p', :desc => "Path for the file."
    def new
      config_name = "bot_questionare"
      config_name = options[:name] if options[:name]
      say <<-SAY
Welcome!

This bot will help you in creating the questionare file which the bot will use when you create
the config file for your application.
Follow the questionare which will guide you in the process.

After your custom questionare is completed, to generate the config file using this questionare,
use this:

bot generate <config file name>

SAY
      say "Generating new bot questionare file with name [#{config_name}]...", :cyan
      config_path = Dir.pwd
      config_path = options[:path] if options[:path]
      g = New.new config_name, config_path
      g.create
      say "Bot questionare creation completed successfull...", :bold
    end

    desc 'version', 'Display version'
    map %w[-v --version] => :version
    def version
      say "config_bot: #{VERSION}"
      say "Created By Wasiq Bhamla."
    end
  end
end
