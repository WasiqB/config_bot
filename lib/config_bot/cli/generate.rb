require "tty-prompt"
require_relative "../model/bot"
require_relative "../model/choice"
require_relative "../model/question"
require_relative "../model/result"
require_relative "../helper/common"
require_relative "../helper/prompt"
require "yaml"

module ConfigBot
  class Generate
    attr_reader :path, :name, :bot
    attr_accessor :config_file, :prompt

    def initialize path, name
      @path = path
      @name = name
    end

    def generate
      load_config
      start
    end

    private
    def load_config
      yaml = YAML.load_file config_file
      bot = ConfigBot.new yaml["name"], yaml["prefix"], yaml["color"].to_sym
      bot.load_questions yaml
    end
  end
end
