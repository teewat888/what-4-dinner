class What4eat::CLI
    def start
    prompt = TTY::Prompt.new
    #system("clear")
    keyword = prompt.ask("what you want to have tonight")
    results = What4eat::APIClient.get_recipes_by_keyword(keyword)
    if total_results(results) > 0
        What4eat::Recipe.new_from_api(results)
    else
        puts "can not find your query, can you try something like pasta"
        start
    end
    print_recipes
    #puts What4eat::Recipe.all
    choice = prompt.ask("what you want to do next (y/n)")
        if choice == 'y'
            reset_results
            start
        else 
            exit
        end
    end

    def print_recipes
        What4eat::Recipe.all.each do |recipe|
            puts recipe.title
        end
    end

    def reset_results
        What4eat::Recipe.all.clear
    end

    def total_results(res)
        What4eat::Recipe.total_results(res)
    end

end