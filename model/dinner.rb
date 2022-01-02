class What4eat::Dinner 
    attr_accessor :url, :title, :ingredients, :methods
    @@all = []

    def initialize(title = nil, url = nil)
        @title = title
        @url = url
        @@all << self
    end

    def self.all
        @@all
    end

    def self.add_details_from_scraper(url, ingredients, methods)
        dinner = self.find_by(url)
        dinner.ingredients = ingredients
        dinner.methods = methods
        dinner
    end

    def self.find_by(url)
        @@all.detect {|el| el.url == url}
    end
end