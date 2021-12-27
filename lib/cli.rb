class What4eat::CLI
    def start
   # What4eat::Scraper.new.make_dinners
    prompt = TTY::Prompt.new
    system("clear")
    # keyword = prompt.ask("what you want to have tonight")
    
    choices = [{name: "Search dinner idea by keyword", value: "useAPI"},
                    {name: "Top 10 Dinner ideas from taste.com.au", value: "useScraper"}]
    main_choice = prompt.select("What do you like to do?", choices)
        if main_choice == "useAPI"
            api_menu(prompt)
        else
            scraper_menu(prompt)
        end
    
    
        choice = prompt.ask("what you want to do next (y/n)")
        if choice == 'y'
            reset_results
            start
        else 
            exit
        end
    end

    def api_menu(prompt)
        keyword = prompt.ask("what you want to have tonight?")
        results = What4eat::APIClient.get_recipes_by_keyword(keyword)
        if total_results(results) > 0
            What4eat::Recipe.new_from_api(results)
            id = prompt.select("What recipe you like to cook?", recipe_list_items, per_page: 10)

            recipe_details = What4eat::APIClient.get_recipe_details(id)

            recipe = What4eat::Recipe.add_details_from_api(id, recipe_details)

            print_recipe(recipe)
        else
            puts "can not find your query, can you try something like pasta"
            api_menu(prompt)
        end
    end

    def scraper_menu(prompt)
        What4eat::Scraper.new.make_dinners
        id = prompt.select("Which one of top ten dinner you like to see the recipe?", dinner_list_items, per_page: 10)
    end

    def dinner_list_items
        choices = What4eat::Dinner.all.collect do |el|
            {name: el.name, value: el.url}
        end
        choices
    end

    def recipe_list_items
        choices = What4eat::Recipe.all.collect do |el|
            {name: el.title, value: el.id}
        end
        choices
    end

    def print_recipe(recipe)
        puts recipe.title
        puts recipe.ingredients
        puts recipe.methods
    end

    def reset_results
        What4eat::Recipe.all.clear
    end

    def total_results(res)
        What4eat::Recipe.total_results(res)
    end

end