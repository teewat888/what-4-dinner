class What4eat::Scraper
    def get_page
        #scrape from top ten dinners right now (https://www.taste.com.au/dinner)
        Nokogiri::HTML(open("https://www.taste.com.au/dinner"))
    end

    def get_page_details(url)
        Nokogiri::HTML(open("https://www.taste.com.au"+url))
    end

    def get_dinners
        #dinners list = dinner.css("div.carousel-with-title.dinner-top-picks div.carousel-item div.card-body a").text
        #dinner_url = dinner.css("div.carousel-with-title.dinner-top-picks div.carousel-item div.card-body a").attribute("href").value
        self.get_page.css("div.carousel-with-title.dinner-top-picks div.carousel-item div.card-body a")
        #binding.pry
    end

    def get_dinner_details

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

