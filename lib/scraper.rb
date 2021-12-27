require "pry"
require "nokogiri"
require "open-uri"
#class What4eat::Scraper
class Scraper
    def get_page
        #scrape from top ten dinners right now (https://www.taste.com.au/dinner)
        Nokogiri::HTML(open("https://www.taste.com.au/dinner"))
    end

    def get_dinners
        #dinners list = dinner.css("div.carousel-with-title.dinner-top-picks div.carousel-item div.card-body a").text
        #dinner_url = dinner.css("div.carousel-with-title.dinner-top-picks div.carousel-item div.card-body a").attribute("href").value
        self.get_page.css("div.carousel-with-title.dinner-top-picks div.carousel-item div.card-body a")
        #binding.pry
    end

    def make_dinners
        self.get_dinners.each do |dinner|
            p dinner.text
            p dinner.attribute("href").value
        end
    end
end

Scraper.new.make_dinners