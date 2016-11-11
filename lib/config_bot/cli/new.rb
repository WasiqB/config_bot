require_relative "../model/bot"
require_relative "../model/choice"
require_relative "../model/question"
require_relative "../model/result"
require_relative "../helper/common"
require_relative "../helper/prompt"
require "yaml"

module ConfigBot
  class New
    attr_reader :bot, :prompt, :options, :queries, :config_path, :config_name, :color

    def initialize name, path
      @config_path = path
      @config_name = name
      @prompt = Prompt.new
      @options = {}
      @queries = []
    end

    def create
      set_name
      set_prefix
      set_color
      set_queries
      save
    end

    private
    def set_name
      options[:name] = prompt.ask "What name you want to give to your bot?", required: true
    end

    def set_prefix
      options[:prefix] = prompt.ask "What prefix you want to give for the bot?", default: "[?] "
    end

    def set_color
      options[:color] = prompt.ask "What color you want to give your bot?", \
        default: :cyan, convert: :symbol
    end

    def set_queries
      @bot = ConfigBot.new name: options[:name], prefix: options[:prefix], color: options[:color]
      question_count = prompt.ask "How many questions you want for your bot?", \
        required: true, convert: :int
      question_count.times do
        question = set_question
        bot.add_question question
      end
    end

    def set_question
      question = Question.new
      question.id = prompt.ask "What is the [ID] for the question?", required: true
      question.type = prompt.select "What is the [Type] for the question?", \
        Common::TYPES, required: true
      question.query = prompt.ask "What question you want to ask?", required: true
      question.default = prompt.ask "What default value you expect for your question?"
      question.convert = prompt.select "What type you want the question input to be converted?", \
        Common::CONVERTS, required: true
      case question.type
      when 3
        question.positive = prompt.ask "What is the positive value you want?", required: true
        question.negative = prompt.ask "What is the negative value you want?", required: true
        question.convert = :bool
      when 4, 5, 6
        choice_count = prompt.ask "How many choices are there for your question?", \
          required: true, convert: :int
        (1..choice_count).each do |i|
          item = ask "#{i}. Add choice: ", required: true
          id = ask "#{i}. Choice id: ", required: true
          choice = Choice.new item, id
          question.add_choice choice
        end
      end
      if prompt.yes? "Do your question expects any results?", required: true, convert: :bool
        result_count = prompt.ask "How many results are there?", required: true, convert: :int
        (1..result_count).each do |i|
          value = prompt.ask "#{i}. What value this result can have?", required: true
          result = Result.new value
          question_count = prompt.ask "#{i}. How many questions your result have?", \
            required: true, convert: :int
          question_count.times do
            result.questions.push set_question
          end
          question.add_result result
        end
      end
      question
    end

    def save
      yaml = bot.to_hash.to_yaml
      path = "#{config_path}/#{config_name}.yaml"
      open(path, "w") do |file|
        file.write yaml
      end
    end
  end
end
