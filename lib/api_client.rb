class What4eat::APIClient
    ## API client to connect to spoonacular api
    BASE_URL = 'https://api.spoonacular.com/recipes'

    def self.get_recipes_by_keyword(keyword)
        uri = URI.parse(BASE_URL + '/complexSearch?query=' + keyword + '&apiKey=' + API_KEY)
        results = uri_json(uri)
    end

    def self.get_recipe_details(id)
        uri = URI.parse(BASE_URL + '/' + id + '/information?instructionsRequired=true&apiKey=' + API_KEY)
        results = uri_json(uri)   
    end

    def self.uri_json(uri)
        begin 
            res = Net::HTTP.get_response(uri)
            if res.is_a?(Net::HTTPSuccess)
                results =  JSON.parse(res.body)
            end
        rescue StandardError
            puts "received an error from the API"
        end
    end
    
end