require "tty-prompt"
require_relative "../model/bot"
require_relative "../model/choice"
require_relative "../model/question"
require_relative "../model/result"
require_relative "../helper/common"
require_relative "../helper/prompt"
require "yaml"

module ConfigBot
  class Generate
    attr_reader :path, :name, :bot, :prompt
    attr_accessor :config_file

    def initialize path, name
      @path = path
      @name = name
    end

    def generate
      check_path
      load_config
      result = {}
      start result
      save result
    end

    private
    def start store
      message = <<-SAY

Welcome to config_bot!!

Hi! My name is #{bot.name}, I'm your bot and I'll guide you in creating your
config file.

	Please follow the following questionare in order to complete the config file creation.
        SAY
      prompt.say message
      ask_questions bot.questions, store
    end

    def save store
      yaml = store.to_yaml
      config_path = File.join path, "#{name}.yaml"
      open(config_path, "w") do |file|
        file.write yaml
      end
    end

    def ask_questions questions, store, prefix = ""
      questions.each_with_index do |question, index|
        res = nil
        query = "#{prefix}#{index + 1}. #{question.query}"
        case question.type
        when "ask"
          res = prompt.ask query, default: question.default, \
            required: question.required, convert: question.convert
        when "mask"
          res = prompt.mask query, default: question.default, \
            required: question.required, convert: question.convert, mask: question.mask
        when "yes?"
          res = prompt.yes? query, default: question.default, \
            required: question.required, convert: question.convert, \
            positive: question.positive, negative: question.negative
        when "select"
          options = get_choices question.choices
          res = prompt.select query, options, default: question.default, \
            required: question.required, help: question.help_msg
        when "multi_select"
          options = get_choices question.choices
          res = prompt.multi_select query, options, \
            default: question.default, required: question.required, help: question.help_msg
        when "enum_select"
          options = get_choices question.choices
          res = prompt.enum_select query, options, \
            default: question.default, required: question.required, help: question.help_msg
        when "multiline"
          res = prompt.multiline query, default: question.default, \
            required: question.required, convert: question.convert
        when "slider"
          res = prompt.slider query, default: question.default, \
            required: question.required, convert: question.convert, \
            min: question.min, max: question.max, step: question.step
        end
        if !res.nil?
          store[question.id] = res
          result = question.results.select do |r|
            r.value == res
          end
          if result.length == 1
            ask_questions result[0].questions, store, "#{index + 1}."
          elsif result.length > 1
            raise Error, "ERROR: More then 1 matchig result found."
          end
        end
      end
    end

    def get_choices choices
      opt = {}
      choices.each do |choice|
        opt[choice.item] = choice.id
      end
      opt
    end

    def check_path
      if !File.exist? config_file
        raise IOError, "ERROR: #{config_file} doesn't exists."
      end
    end

    def load_config
      yaml = YAML.load_file config_file
      @bot = ConfigBot.new body: yaml
      @prompt = Prompt.new prefix: bot.prefix, color: bot.color
    end
  end
end
