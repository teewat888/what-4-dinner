class What4eat::Dinner 
    attr_accessor :url, :name, :ingredients, :methods
    @@all = []

    def initialize(name = nil, url = nil)
        @name = name
        @url = url
        @@all << self
    end

    def self.all
        @@all
    end

    def find_by(name)
        @@all.detect {|el| el.name == name}
    end
end