class What4Dinner::CLI

    attr_accessor :prompt, :pastel, :search_results

    def initialize
        @prompt = TTY::Prompt.new
        @pastel = Pastel.new
        @search_results = nil
    end

    def start    
    system("clear")
    banner
    choices = [{name: "Search dinner ideas by keyword", value: "useAPI"},
                    {name: "Top 10 Dinner ideas from taste.com.au", value: "useScraper"},
                {name: "Exit", value: "exit"}]
    main_choice = prompt.select("What do you like to do?", choices)
        if main_choice == "useAPI"
            api_menu
        elsif main_choice == "useScraper"
            scraper_menu
        else
            exit
        end
    end

    def end_menu(from)
        if (from == 'api')
            choices = [{name: "Main Menu", value: "main_menu"},
            {name: "Back to search results", value: "back"},
            {name: "Change Unit", value: "unit"},    
            {name: "Exit", value: "exit"}]
        else
            choices = [{name: "Main Menu", value: "main_menu"},
            {name: "Back to search results", value: "back"},
            {name: "Exit", value: "exit"}]
        end
        choice = prompt.select("?", choices)
        if choice == 'main_menu'
            reset_results
            start
        elsif choice == 'unit'
            unit_menu
        elsif choice == 'back'
            back_menu(from)
        else
            exit
        end
    end

    def unit_menu
        choices = [{name: "Metice", value: "metric"},
                {name: "US", value: "us"}]
        choice = prompt.select("Which unit?", choices)
        set_unit(choice)
        print_recipe(current_recipe)
        end_menu('api')
    end

    def back_menu(from)
        if from == 'api'
            api_get_details
        else
            scraper_menu_detail
        end
    end

    def api_menu

        spinner = TTY::Spinner.new("[:spinner] Loading ...", format: :pulse_2)        
        keyword = prompt.ask("what you want to have tonight?", required: true)
        results = What4Dinner::APIClient.get_recipes_by_keyword(keyword)
        offset = 0
        number = result_per_page(results)
        total_results = total_results(results)

        if total_results(results) > 0
            spinner.auto_spin # Automatic animation with default interval
            add_to_recipe(results)
            #check still have result in the pagination
            while total_results - number - offset > 0
                offset += number
                results = What4Dinner::APIClient.get_recipes_by_keyword_with_offset(keyword, offset, number)
                add_to_recipe(results)
            end
            spinner.stop("Done!") # Stop animation
            api_get_details
            
        else
            puts "can not find your query, can you try something like pasta"
            api_menu
        end
    end

    def api_get_details
        if !search_results.nil?
             id = prompt.enum_select("What recipe you like to cook?", search_results, per_page: 10)
        else
        id = prompt.enum_select("What recipe you like to cook?", recipe_list_items, per_page: 10)
        end
        recipe_details = What4Dinner::APIClient.get_recipe_details(id)

        recipe = What4Dinner::Recipe.add_details_from_api(id, recipe_details)
        recipe_h = {id: id, res: recipe_details}
        set_current_recipe(recipe_h)
        print_recipe(recipe)
        end_menu('api')
    end

    def scraper_menu
        What4Dinner::Scraper.new.make_dinners
        scraper_menu_detail
    end

    def scraper_menu_detail
        if !search_results.nil?
            url = prompt.select("Which one of top ten dinner you like to see the recipe?", search_results, per_page: 10)
        else
            url = prompt.select("Which one of top ten dinner you like to see the recipe?", dinner_list_items, per_page: 10)
        end

        dinner_details = What4Dinner::Scraper.new.make_details(url)

        print_recipe(dinner_details)
        end_menu('scraper')
    end

    def dinner_list_items
        choices = What4Dinner::Dinner.all.collect do |el|
            {name: el.title, value: el.url}
        end
        search_results = choices
        choices
    end

    def recipe_list_items
        choices = What4Dinner::Recipe.all.collect do |el|
            {name: el.title, value: el.id}
        end
        search_results = choices
        choices
    end

    def print_recipe(recipe)
        new_line
        print pastel.on_red(recipe.title) + ' '
        print "Cooking time # #{recipe.cooking_times}m || " if recipe.class.method_defined? :cooking_times
        print "Servings # #{recipe.servings}" if recipe.class.method_defined? :servings
        new_line
        new_line
        puts pastel.on_red("## Ingredients ##")
        puts recipe.ingredients
        new_line
        puts pastel.on_red("## Methods ##")
        puts recipe.methods
        new_line
    end

    def banner
        puts "#######################################"
        puts "#### What 4 dinner cli application ####"
        puts "####         version 1.00        ######"
        puts "#######################################"
    end

    def new_line
        puts ""
    end

    def add_to_recipe(res)
        What4Dinner::Recipe.new_from_api(res)
    end

    def reset_results
        What4Dinner::Recipe.all.clear
        search_results = nil
    end

    def total_results(res)
        What4Dinner::Recipe.total_results(res)
    end

    def result_per_page(res)
        What4Dinner::Recipe.result_per_page(res)
    end

    def set_unit(unit)
        What4Dinner::Recipe.unit = unit
    end
    #require hash of id and result set of current recipe
    def set_current_recipe(recipe)
        What4Dinner::Recipe.current_recipe = recipe
    end

    def current_recipe
        What4Dinner::Recipe.current_recipe
    end

end