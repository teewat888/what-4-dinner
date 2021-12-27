require "pry"
require "nokogiri"
require "open-uri"

class TestScraper
    def get_page
        #scrape from top ten dinners right now (https://www.taste.com.au/dinner)
        Nokogiri::HTML(open("https://www.taste.com.au/dinner"))
    end

    #def get_page_details(url)
    def get_page_details
        Nokogiri::HTML(open("https://www.taste.com.au"+"/recipes/gingerbread-men/3a04ab1d-a84a-424f-800a-7ebcbe92fa09?r=dinner&h=Dinner"))
    end

    def get_dinners
        #dinners list = dinner.css("div.carousel-with-title.dinner-top-picks div.carousel-item div.card-body a").text
        #dinner_url = dinner.css("div.carousel-with-title.dinner-top-picks div.carousel-item div.card-body a").attribute("href").value
        self.get_page.css("div.carousel-with-title.dinner-top-picks div.carousel-item div.card-body a")
        #binding.pry
    end

    def get_dinner_details
        #details = .css("article.row.tabs-container div.tabs.mobile-only")
        #ingredient = details.css("div#tabIngredients ul li div.ingredient-description").text.strip
        ## add this to remove span tags and content details.css("div#tabMethodSteps ul li div.recipe-method-step-content").search('//span').remove
        #methods = details.css("div#tabMethodSteps ul li div.recipe-method-step-content").text.strip
        res = self.get_page_details.css("article.row.tabs-container div.tabs.mobile-only").first
        binding.pry
    end

    def make_details
    end

    def make_dinners
        self.get_dinners.each do |dinner|
            name = dinner.text
            url = dinner.attribute("href").value
            What4eat::Dinner.new(name, url)
        end
    end
end

TestScraper.new.get_dinner_details
