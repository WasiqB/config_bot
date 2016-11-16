module ConfigBot
  class ConfigBot
    attr_reader :name, :questions, :prefix, :color

    def initialize body: nil, name: "config-bot", prefix: "[?] ", color: :cyan
      @questions = []
      if body.nil?
        @name = name
        @prefix = prefix
        @color = color
      else
        @name = body["name"]
        @prefix = body["prefix"]
        @color = body["color"].to_sym
        set_questions body["queries"], questions
      end
    end

    def add_question question
      questions.push question
    end

    def to_hash
      { "name"=> name, "prefix"=> prefix, "color"=> color, \
        "queries"=> questions.map { |q| q.to_hash } }
    end

    private
    def set_questions queries, question_arr
      queries.each do |q|
        hash = q["question"]
        question = Question.new
        question.id = hash["id"]
        question.type = hash["type"]
        question.query = hash["query"]
        question.default = hash["default"]
        question.mask = hash["mask"]
        question.positive = hash["positive"]
        question.negative = hash["negative"]
        question.convert = hash["convert"]
        question.required = hash["required"]
        question.help_msg = hash["help_msg"]
        question.min = hash["min"]
        question.max = hash["max"]
        question.step = hash["step"]
        question.choices = get_choices hash["choices"]
        question.results = get_results hash["results"]
        question_arr.push question
      end
    end

    def get_choices choices
      if choices
        arr = Array.new(choices.length)
        choices.each do |c|
          hash = c["choice"]
          choice = Choice.new hash["item"], hash["id"]
          arr.push choice
        end
        return arr.compact
      end
      []
    end

    def get_results results
      if results
        arr = Array.new(results.length)
        results.each do |r|
          hash = r["result"]
          result = Result.new hash["value"]
          set_questions hash["queries"], result.questions
          arr.push result
        end
        return arr.compact
      end
      []
    end
  end
end
