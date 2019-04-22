class Recipe
  attr_reader :name, :description, :preptime, :rating, :done

  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description] || ""
    @preptime = attributes[:preptime] || "unkown"
    @rating = attributes[:rating] || "no rating yet"
    @done = attributes[:done] || false
  end

  def mark_as_done!
    @done = true
  end
end
