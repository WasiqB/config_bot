class Choice
  attr_reader :item, :id, :name

  def initialize item, id, name = "choice"
    @name = name
    @item = item
    @id = id
  end

  def to_hash
    { name=> { "item"=> item, "id"=> id } }
  end
end
