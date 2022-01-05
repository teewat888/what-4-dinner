$prompt = TTY::Prompt.new
$pastel = Pastel.new

class What4Dinner::CLI

    def start    
    system("clear")
    banner
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
    end

    def end_menu
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
        spinner = TTY::Spinner.new("[:spinner] Loading ...", format: :pulse_2)        
        keyword = $prompt.ask("what you want to have tonight?", required: true)
        results = What4Dinner::APIClient.get_recipes_by_keyword(keyword)
        offset = 0
        number = result_per_page(results)
        total_results = total_results(results)

        if total_results(results) > 0
            #What4Dinner::Recipe.new_from_api(results)
            spinner.auto_spin # Automatic animation with default interval
            add_to_recipe(results)

            while total_results - number - offset > 0
                offset += number
                results = What4Dinner::APIClient.get_recipes_by_keyword_with_offset(keyword, offset, number)
                add_to_recipe(results)
            end
            spinner.stop("Done!") # Stop animation
            id = $prompt.enum_select("What recipe you like to cook?", recipe_list_items, per_page: 10)

            recipe_details = What4Dinner::APIClient.get_recipe_details(id)

            recipe = What4Dinner::Recipe.add_details_from_api(id, recipe_details)

            print_recipe(recipe)
            end_menu
        else
            puts "can not find your query, can you try something like pasta"
            api_menu
        end
    end

    def scraper_menu
        What4Dinner::Scraper.new.make_dinners

        url = $prompt.select("Which one of top ten dinner you like to see the recipe?", dinner_list_items, per_page: 10)

        dinner_details = What4Dinner::Scraper.new.make_details(url)

        print_recipe(dinner_details)
        end_menu
    end

    def dinner_list_items
        choices = What4Dinner::Dinner.all.collect do |el|
            {name: el.title, value: el.url}
        end
        choices
    end

    def recipe_list_items
        choices = What4Dinner::Recipe.all.collect do |el|
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

    def banner
        puts "#####################################"
        puts "####  What 4 eat cli application ####"
        puts "####         version 1.00        ####"
        puts "#####################################"

    end

    def new_line
        puts ""
    end

    def add_to_recipe(res)
        What4Dinner::Recipe.new_from_api(res)
    end

    def reset_results
        What4Dinner::Recipe.all.clear
    end

    def total_results(res)
        What4Dinner::Recipe.total_results(res)
    end

    def result_per_page(res)
        What4Dinner::Recipe.result_per_page(res)
    end

end