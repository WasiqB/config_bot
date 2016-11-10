class Result
  attr_reader :value, :name
  attr_accessor :questions

  def initialize name = "result", value
    @name = name
    @value = value
    @questions = []
  end

  def to_hash
    queries = questions.map { |q| q.to_hash }
    { name=> { "value"=> value, "queries"=> queries } }
  end
end
