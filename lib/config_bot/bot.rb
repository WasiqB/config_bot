module ConfigBot
    class ConfigBot
        attr_reader :name, :questions

        def initialize name = "config-bot"
            @name = name
            @questions = []
        end

        def add_question question
            @questions.push question
        end

        def load_questions yaml
            @questions = yaml["queries"]
        end

        def to_hash
            { "name"=> name, "queries"=> questions.map { |q| q.to_hash } }
        end
    end
end
