require "tty-prompt"
require "../model/bot"
require "../model/choice"
require "../model/queston"
require "../model/result"
require "yaml"

module ConfigBot
    class New
        attr_reader :yaml, :bot

        def initialize name, path
            @yaml = YAML.load_file "#{path}#{name}"
            @bot = ConfigBot.new yaml["name"]
            @bot.load_questions yaml
        end

        def create
            # TODO
        end
    end
end
