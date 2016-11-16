class Question
  attr_accessor :name, :id, :type, :query, :default, :mask, :positive, :negative, \
    :convert, :required, :results, :choices, :help_msg, :min, :max, :step

  def initialize name = "question"
    @name = name
    @results = []
    @choices = []
  end

  def add_choice choice
    @choices.push choice
  end

  def add_result result
    @results.push result
  end

  def to_hash
    fields = %w{id type query default mask positive negative convert choices results required help_msg min max step}
    question = {}
    fields.each do |field|
      val = instance_variable_get "@#{field}"
      if val
        if field == "choices" || field == "results"
          arr = val.map { |c| c.to_hash }
          question[field] = arr if arr.length > 0
        else
          question[field] = val
        end
      end
    end
    { name=> question } if question.keys.length > 0
  end
end
