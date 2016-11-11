module ConfigBot
  class ConfigBot
    attr_reader :name, :questions, :prefix, :color

    def initialize name: "config-bot", prefix: "[?] ", color: :cyan
      @name = name
      @prefix = prefix
      @color = color
      @questions = []
    end

    def add_question question
      @questions.push question
    end

    def load_questions yaml
      @questions = yaml["queries"]
    end

    def to_hash
      { "name"=> name, "prefix"=> prefix, "color"=> color, \
        "queries"=> questions.map { |q| q.to_hash } }
    end
  end
end
