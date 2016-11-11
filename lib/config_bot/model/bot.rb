module ConfigBot
  class ConfigBot
    attr_reader :name, :questions, :prefix

    def initialize name = "config-bot", prefix = "[?] "
      @name = name
      @prefix = prefix
      @questions = []
    end

    def add_question question
      @questions.push question
    end

    def load_questions yaml
      @questions = yaml["queries"]
    end

    def to_hash
      { "name"=> name, "prefix"=> prefix, "queries"=> questions.map { |q| q.to_hash } }
    end
  end
end
