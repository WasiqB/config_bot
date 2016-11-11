class Result
  attr_reader :value, :name
  attr_accessor :questions

  def initialize value, name = "result"
    @name = name
    @value = value
    @questions = []
  end

  def to_hash
    results = {}
    results["value"] = value
    queries = questions.map { |q| q.to_hash }
    results["queries"] = queries if queries.length > 0
    { name=> results }
  end
end
