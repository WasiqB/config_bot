require 'thor'
require 'yaml'
require_relative 'cli/generate'
require_relative "cli/new"

module ConfigBot
  class Bot < Thor
    check_unknown_options!

    def self.exit_on_failure?
      true
    end

    class_option :verbose, :type => :boolean, :default => false

    desc "generate [NAME]", "Name of config file to be created."
    map %w[g --gen] => :generate
    method_option :path, :aliases => "-p", :desc => "Path for the config file."
    method_option :config, :aliases => "-c", :desc => "Path for the questionare file."
    def generate name
      path = Dir.pwd
      path = options[:path] if options[:path]

      config_name = "#{Dir.pwd}/bot_questionare.yaml"
      config_name = options[:config] if options[:config]

      say "Generating new config file with name [#{name}.yaml]...", :cyan

      gen = Generate.new path, name
      gen.config_file = config_name
      gen.generate

      say "Config file creation completed successfull and saved @ [#{path}]...", :bold
    end

    desc "new", "Creates new questionare file for your bot."
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
      say "Generating new bot questionare file with name [#{config_name}.yaml]...", :cyan
      config_path = Dir.pwd
      config_path = options[:path] if options[:path]

      g = New.new config_name, config_path
      g.create

      say "Bot questionare creation completed successfull and saved @ [#{config_path}]...", :bold
    end

    desc 'version', 'Display version'
    map %w[-v --version] => :version
    def version
      say "config_bot: #{VERSION}"
      say "Created By Wasiq Bhamla.", :bold
    end
  end
end
