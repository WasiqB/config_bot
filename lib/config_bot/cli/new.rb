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
      (1..question_count).each do |i|
        question = set_question i
        bot.add_question question
      end
    end

    def set_question index, prefix = ""
      question_id = "#{prefix}#{index}"
      question = Question.new
      question.id = prompt.ask "#{question_id}.1. What is the unique id for the question?", \
        required: true
      type = prompt.select "#{question_id}.2. What is the type of question u want to ask?", \
        Common::TYPES, required: true
      question.type = Common::TYPES[type - 1]
      question.query = prompt.ask "#{question_id}.3. What question you want to ask?", \
        required: true
      convert = prompt.select "#{question_id}.4. What type you want the question input to be converted to?", \
        Common::CONVERTS, required: true, default: 10
      question.convert = Common::CONVERTS[convert - 1].to_sym
      question.default = prompt.ask "#{question_id}.5. What default value you expect for your question?", \
        convert: question.convert
      question.required = prompt.yes? "#{question_id}.6. Is your question mandatory?", \
        default: false, convert: :bool
      if prompt.yes? "#{question_id}.7. Do your question expects any results?", \
          required: true, convert: :bool
        result_count = prompt.ask "#{question_id}.7.1. How many results are there?", \
          required: true, convert: :int
        (1..result_count).each do |i|
          value = prompt.ask "#{question_id}.7.1.#{i}.1. What value this result can have?", \
            required: true, convert: question.convert
          result = Result.new value
          question_count = prompt.ask "#{question_id}.7.1.#{i}.2. How many questions your result have?", \
            required: true, convert: :int
          (1..question_count).each do |id|
            result.questions.push set_question id, "#{question_id}.7.1.#{id}.2."
          end
          question.add_result result
        end
      end
      case question.type
      when "mask"
        question.mask = prompt.ask "#{question_id}.8. What mask value you want for your question?", \
          required: true
      when "yes?"
        question.positive = prompt.ask "#{question_id}.8.1. What is the positive value you want?", \
          required: true
        question.negative = prompt.ask "#{question_id}.8.2. What is the negative value you want?", \
          required: true
      when "select", "multi_select", "enum_select"
        choice_count = prompt.ask "#{question_id}.8.1. How many choices are there for your question?", \
          required: true, convert: :int
        (1..choice_count).each do |i|
          item = prompt.ask "#{question_id}.8.1.#{i}.1. Add choice:", required: true
          id = prompt.ask "#{question_id}.8.1.#{i}.2. Choice id:", \
            required: true, convert: question.convert
          choice = Choice.new item, id
          question.add_choice choice
        end
        question.help_msg = prompt.ask "#{question_id}.8.2. What help message u want?"
      when "slider"
        question.min = prompt.ask "#{question_id}.8.1. What is the min value for slider?", \
          required: true, convert: :int
        question.max = prompt.ask "#{question_id}.8.2. What is the max value for slider?", \
          required: true, convert: :int
        question.step = prompt.ask "#{question_id}.8.3. What is the step value for slider?", \
          required: true, convert: :int
      end
      question
    end

    def save
      yaml = bot.to_hash.to_yaml
      path = File.join config_path, "#{config_name}.yaml"
      open(path, "w") do |file|
        file.write yaml
      end
    end
  end
end
