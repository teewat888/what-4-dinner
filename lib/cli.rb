class What4eat::CLI
    def start
    prompt = TTY::Prompt.new
    #system("clear")
    keyword = prompt.ask("what you want to have tonight")
    results = What4eat::APIClient.get_recipes_by_keyword(keyword)
        if total_results(results) > 0
            What4eat::Recipe.new_from_api(results)
            id = prompt.select("What recipe you like to cook?", recipe_list_items, per_page: 10)

            recipe_details = What4eat::APIClient.get_recipe_details(id)

            recipe = What4eat::Recipe.add_details_from_api(id, recipe_details)

            print_recipe(recipe)
        else
            puts "can not find your query, can you try something like pasta"
            start
        end
    
        choice = prompt.ask("what you want to do next (y/n)")
        if choice == 'y'
            reset_results
            start
        else 
            exit
        end
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