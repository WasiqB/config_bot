require "tty-prompt"

module ConfigBot
  class Prompt
    attr_reader :prompt, :color

    def initialize prefix: "[?] ", color: :cyan
      @prompt = TTY::Prompt.new prefix: prefix
      @color = color
    end

    def say message, color: :cyan
      prompt.say message, color: color
    end

    def ok message
      prompt.ok message
    end

    def warn message
      prompt.warn message
    end

    def error message
      prompt.error message
    end

    def select query, choices, default: 1, required: false, help: nil
      list = choices
      list = choices.map.with_index { |v, i| [v, i + 1] }.to_h if choices.kind_of? Array

      prompt.select(query, required: required, active_color: color, help: help) do |menu|
        menu.default( default )
        menu.enum '.'
        list.each do |k, v|
          menu.choice k, v
        end
      end
    end

    def enum_select query, choices, default: 1, required: false, help: nil
      list = choices
      list = choices.map.with_index { |v, i| [v, i + 1] }.to_h if choices.kind_of? Array

      prompt.enum_select(query, required: required, active_color: color, help: help) do |menu|
        menu.default( default )
        menu.enum '.'
        list.each do |k, v|
          menu.choice k, v
        end
      end
    end

    def multi_select query, choices, default: [], required: false, help: nil
      list = choices
      list = choices.map.with_index { |v, i| [v, i + 1] }.to_h if choices.kind_of? Array

      prompt.multi_select(query, required: required, active_color: color, help: help) do |menu|
        menu.default( default )
        menu.enum '.'
        list.each do |k, v|
          menu.choice k, v
        end
      end
    end

    def slider query, default: nil, required: false, convert: :string, min: 1, max: 10, step: 1
      prompt.slider query, required: required, active_color: color do |range|
        range.default( default ) if default
        range.min min
        range.max max
        range.step step
        range.convert( convert ) if convert
      end
    end

    def ask query, default: nil, required: false, convert: :string
      prompt.ask query, required: required, active_color: color do |q|
        q.default( default ) if default
        q.convert( convert ) if convert
      end
    end

    def multiline query, default: nil, required: false, convert: :string
      prompt.multiline query, required: required, active_color: color do |q|
        q.default( default ) if default
        q.convert( convert ) if convert
      end
    end

    def mask query, default: nil, required: false, convert: :string, mask: '*'
      prompt.mask query, mask: mask, required: required, active_color: color do |m|
        m.default( default ) if default
        m.convert( convert ) if convert
      end
    end

    def yes? query, default: false, required: false, convert: :bool, positive: 'Yes', negative: 'No'
      prompt.yes? query, required: required, active_color: color do |q|
        q.default( default ) if default
        q.positive( positive ) if positive
        q.negative( negative ) if negative
        q.convert( convert ) if convert
      end
    end
  end
end
