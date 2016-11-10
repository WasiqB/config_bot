class Question
  attr_accessor :name, :id, :type, :query, :default, :color, :suffix, \
    :positive, :negative, :convert, :results, :choices

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
    res = results.map { |r| r.to_hash }
    options = choices.map { |c| c.to_hash }
    { name=> {
        "id"=> id, "type"=> type, "query"=> query, "default"=> default,
        "color"=> color, "suffix"=> suffix, "positive"=> positive,
        "negative"=> negative, "convert"=> convert, "choices"=> options,
        "results"=> res
      }
    }
  end
end
