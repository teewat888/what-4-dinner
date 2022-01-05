class What4Dinner::Scraper
    def get_page
        #scrape from top ten dinners right now (https://www.taste.com.au/dinner)
        Nokogiri::HTML(open("https://www.taste.com.au/dinner"))
    end

    def get_page_details(url)
        Nokogiri::HTML(open("https://www.taste.com.au"+url))
    end

    def get_dinners
        dinners = self.get_page.css("div.carousel-with-title.dinner-top-picks div.carousel-item div.card-body a")
    end

    def get_dinner_details(url)
        self.get_page_details(url).css("article.row.tabs-container div.tabs.mobile-only").first
    end

    def make_details(url)
        details = self.get_dinner_details(url)
        
        ingredients = details.css("div#tabIngredients ul li div.ingredient-description").collect do |el|
            el.text.delete("\n").strip
            end            
            
        methods = details.css("div#tabMethodSteps ul li div.recipe-method-step-content").collect.with_index do |el, index|
            el.search('.tooltip').remove
            "Step #{index+1}: #{el.text.strip}"
            end
       
        What4Dinner::Dinner.add_details_from_scraper(url, ingredients, methods)
    end

    def make_dinners
        self.get_dinners.each do |dinner|
            title = dinner.css("h3").text         
            url = dinner.attribute("href").value
            if title != ""
                What4Dinner::Dinner.new(title, url)
            end
        end
    end
end

