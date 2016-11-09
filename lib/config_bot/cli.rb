require 'thor'
require 'yaml'

module ConfigBot
    class Client < Thor
        desc "config [PATH]", "Description"
        def config path
            if File.exist? path
                yaml = YAML.load_file path
                my_bot = Bot.new yaml["name"]
                my_bot.load_questions yaml
                puts my_bot.to_hash.inspect
            else
                error "File not found!"
            end
        end
    end
end
