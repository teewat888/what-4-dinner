$prompt = TTY::Prompt.new
$pastel = Pastel.new

class What4eat::CLI

    def start
   # What4eat::Scraper.new.make_dinners
    
    system("clear")
    # keyword = prompt.ask("what you want to have tonight")
    
    choices = [{name: "Search dinner ideas by keyword", value: "useAPI"},
                    {name: "Top 10 Dinner ideas from taste.com.au", value: "useScraper"},
                {name: "Exit", value: "exit"}]
    main_choice = $prompt.select("What do you like to do?", choices)
        if main_choice == "useAPI"
            api_menu
        elsif main_choice == "useScraper"
            scraper_menu
        else
            exit
        end
    
    choices = [{name: "Main Menu", value: "main_menu"},
                {name: "Exit", value: "exit"}]
        choice = $prompt.select("What you want to do next?", choices)
        if choice == 'main_menu'
            reset_results
            start
        else 
            exit
        end
    end

    def api_menu
        keyword = $prompt.ask("what you want to have tonight?", required: true)
    
        results = What4eat::APIClient.get_recipes_by_keyword(keyword)
        if total_results(results) > 0
            What4eat::Recipe.new_from_api(results)
            id = $prompt.select("What recipe you like to cook?", recipe_list_items, per_page: 10)

            recipe_details = What4eat::APIClient.get_recipe_details(id)

            recipe = What4eat::Recipe.add_details_from_api(id, recipe_details)

            print_recipe(recipe)
        else
            puts "can not find your query, can you try something like pasta"
            api_menu
        end
    end

    def scraper_menu
        What4eat::Scraper.new.make_dinners

        url = $prompt.select("Which one of top ten dinner you like to see the recipe?", dinner_list_items, per_page: 10)

        dinner_details = What4eat::Scraper.new.make_details(url)

        print_recipe(dinner_details)
    end

    def dinner_list_items
        choices = What4eat::Dinner.all.collect do |el|
            {name: el.title, value: el.url}
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
        new_line
        puts $pastel.on_red(recipe.title)
        new_line
        puts $pastel.on_red("## Ingredients ##")
        puts recipe.ingredients
        new_line
        puts $pastel.on_red("## Methods ##")
        puts recipe.methods
        new_line
    end

    def new_line
        puts ""
    end

    def reset_results
        What4eat::Recipe.all.clear
    end

    def total_results(res)
        What4eat::Recipe.total_results(res)
    end

end