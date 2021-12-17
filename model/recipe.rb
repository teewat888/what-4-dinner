class What4eat::Recipe
    attr_accessor :id, :title, :url, :ingredients, :methods

    @@all = []
    
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
        recipe
    end

    def self.find(id)
        @@all.detect { |el| el.id = id}
    end

    def format_ingredients(res)
        
    end

    def format_methods(res)
    end

    def self.all
        @@all
    end

    def self.total_results(res)
        res["totalResults"]
    end

    def self.result_per_page(res)
        res["number"]
    end

    def self.offset(res)
        res["offset"]
    end

    def details
        @details ||= What4eat::APIClient.get_recipe_details
    end

end