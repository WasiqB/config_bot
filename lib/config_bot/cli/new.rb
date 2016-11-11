require "tty-prompt"
require_relative "../model/bot"
require_relative "../model/choice"
require_relative "../model/question"
require_relative "../model/result"
require "yaml"

module ConfigBot
  class New
    attr_reader :bot, :prompt, :options, :queries, :config_path, :config_name, :color

    def initialize name, path, color = :cyan
      @config_path = path
      @config_name = name
      @color = color
      @prompt = TTY::Prompt.new(prefix: '[?] ')
      @options = {}
      @queries = []
    end

    def create
      set_name
      set_prefix
      set_queries
      save
    end

    private
    def set_name
      options[:name] = ask "What name you want to give to your bot?", required: true
    end

    def set_prefix
      options[:prefix] = ask "What prefix you want to give for the bot?", default: "[?] "
    end

    def set_queries
      @bot = ConfigBot.new options[:name], options[:prefix]
      question_count = ask( "How many questions you want for your bot?", required: true ).to_i
      question_count.times do
        question = set_question
        bot.add_question question
      end
    end

    def set_question
      question = Question.new
      question.id = ask "What is the [ID] for the question?", required: true
      question.type = select "What is the [Type] for the question?", \
        %w{ask mask yes? select multi_select enum_select multiline}, required: true
      question.query = ask "What question you want to ask?", required: true
      question.default = ask "What default value you expect for your question?"
      question.color = color
      case question.type
      when 3
        question.positive = ask "What is the positive value you want?", required: true
        question.negative = ask "What is the negative value you want?", required: true
        question.convert = :bool
      when 4, 5, 6
        choice_count = ask( "How many choices are there for your question?", required: true ).to_i
        (1..choice_count).each do |i|
          item = ask "#{i}. Add choice: ", required: true
          id = ask "#{i}. Choice id: ", required: true
          choice = Choice.new item, id
          question.add_choice choice
        end
      end
      if yes?( "Do your question expects any results?", required: true )
        result_count = ask( "How many results are there?", required: true ).to_i
        (1..result_count).each do |i|
          value = ask "#{i}. What value this result can have?", required: true
          result = Result.new value
          question_count = ask( "#{i}. How many questions your result have?", required: true ).to_i
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

    def select query, choices, default: nil, required: false
      prompt.select(query, required: required, active_color: :cyan) do |menu|
        menu.default default if default
        menu.enum '.'
        choices.each_with_index do |choice, index|
          menu.choice choice, index + 1
        end
      end
    end

    def ask query, default: nil, required: false
      prompt.ask query, required: required, active_color: :cyan do |q|
        q.default default if default
      end
    end

    def yes? query, default: false, required: false
      prompt.yes? query, required: required, active_color: :cyan do |q|
        q.default default if default
        q.positive 'Yes'
        q.negative 'No'
        q.convert :bool
      end
    end
  end
end
