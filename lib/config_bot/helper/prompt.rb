require "tty-prompt"

module ConfigBot
  class Prompt
    attr_reader :prompt

    def initialize prefix = "[?] "
      @prompt = TTY::Prompt.new prefix: prefix
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

    def ask query, default: nil, required: false, convert: :string
      prompt.ask query, required: required, active_color: :cyan do |q|
        q.default default if default
        q.convert convert if convert
      end
    end

    def yes? query, default: false, required: false, convert: :bool, positive: 'Yes', negative: 'No'
      prompt.yes? query, required: required, active_color: :cyan do |q|
        q.default default if default
        q.positive positive if positive
        q.negative negative if negative
        q.convert convert if convert
      end
    end
  end
end
