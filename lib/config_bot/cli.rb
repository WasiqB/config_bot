require 'thor'
require 'yaml'

module ConfigBot
    class Bot < Thor
        desc "config [PATH]", "Description"
        def config path
            if File.exist? path
                yaml = YAML.load_file path
                my_bot = ConfigBot.new yaml["name"]
                my_bot.load_questions yaml
                puts my_bot.to_hash.inspect
            else
                error "File not found!"
            end
        end
    end
end
