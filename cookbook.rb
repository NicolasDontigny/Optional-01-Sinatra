require 'csv'

class Cookbook
  def initialize(csv_file_path = nil)
    @csv_file_path = csv_file_path
    @recipes = []
    if csv_file_path
      CSV.foreach(@csv_file_path) do |row|
        done = row[4] == "true"
        recipe_hash = { name: row[0], description: row[1], preptime: row[2], rating: row[3], done: done }
        @recipes << Recipe.new(recipe_hash)
      end
    end
  end

  def all
    # returns all the recipes
    return @recipes
  end

  def csv
    @csv_file_path ? true : false
  end

  def add_recipe(new_recipe)
    # add a new recipe
    @recipes << new_recipe

    save_to_csv
  end

  def remove_recipe(recipe_index)
    # remove a recipe at a particular index (line number)
    @recipes.delete_at(recipe_index)
    save_to_csv if csv
  end

  def mark_as_done!(recipe)
    recipe.mark_as_done!
    save_to_csv if csv
  end

  private

  def save_to_csv
    CSV.open(@csv_file_path, "w") do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.preptime, recipe.rating, recipe.done]
      end
    end
  end
end
