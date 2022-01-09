class What4Dinner::Recipe
    attr_accessor :id, :title, :url, :ingredients, :methods, :servings, :cooking_times

    @@all = []
    @@unit = 'metric'
    @@current_recipe = nil #store hash of recipe id and result set of the id
    
    def initialize(id = nil, title = nil)
        @id = id
        @title = title
        @@all << self
    end

    def self.new_from_api(res)
        res["results"].each do |el|
            self.new(el["id"], el["title"])
        end 
    end

    def self.add_details_from_api(id, res)
        recipe = find(id)
        recipe.ingredients = format_ingredients(res)
        recipe.methods = format_methods(res)
        recipe.servings = res["servings"]
        recipe.cooking_times = res["readyInMinutes"]
        recipe
    end

    def self.update_recipe(current_recipe)
        self.add_details_from_api(current_recipe[:id], current_recipe[:res])
    end

    def self.find(id)
        @@all.detect { |el| el.id == id}
    end

    def self.format_ingredients(res)
        res["extendedIngredients"].collect do |el|
            return_string = "#{el['measures'][self.unit]['amount'].to_s || ''}  #{el['measures'][self.unit]['unitShort'] || ''} #{el['nameClean'] || ''}"
            return_string
        end
    end

    def self.format_methods(res)
        res["analyzedInstructions"].collect do |steps|
            steps["steps"].collect.with_index do |step, index|
                "Step #{index+1}: #{step["step"]}"
            end
        end
    end

    def self.all
        @@all
    end

    def self.unit
        @@unit
    end

    def self.unit=(unit)
        @@unit = unit
    end

    def self.current_recipe
        self.update_recipe(@@current_recipe)
    end

    def self.current_recipe=(recipe_h)
        @@current_recipe = recipe_h
    end

    def self.total_results(res)
        res["totalResults"]
    end

    def self.result_per_page(res)
        res["number"] || 0
    end

end