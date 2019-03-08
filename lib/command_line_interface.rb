class CLI
    attr_reader :api_communicator
    @@start_menu = ["Sign In", "Create Account", "Search without Account", "Exit"]
    @@search_menu = ["Search by Name", "Search by State", "Search by Park Category", "Suprise Me", "Back to Start Menu", "Exit"]

    def initialize (api_communicator)
        @api_communicator=api_communicator # connects to API class

    end

    def run_search
      welcome
      start_menu
    end

    def welcome
        greeting_message

    end

    def goodbye
      goodbye_message
    end

    # MENUS
    def start_menu
        
      puts
      puts "------------------------------------------------------------------------"
      puts "          START MENU"
      puts "------------------------------------------------------------------------"
      puts "What would you like to do?"
      puts "Creating an account lets you save your favorite parks"
      puts "(Please select a number from the list)"
      puts
      api_communicator.printlist(@@start_menu)
      response = gets.chomp.to_i


      if response == 1
        sign_in
      elsif response == 2
        user_search_menu(create_account)
      elsif response == 3
        search_menu
      elsif response == 4
        goodbye
        return
      else
        puts
        puts "Invalid input"
        start_menu
      end
    end

    def search_menu
        
      puts
      puts "------------------------------------------------------------------------"
      puts "          SEARCH MENU"
      puts "------------------------------------------------------------------------"
      puts "Search for infomation about National Parks"
      puts "(Please select a number from the list)"

      puts
      api_communicator.printlist(@@search_menu)
      response = gets.chomp.to_i
    
      if response == 1
        park_view(search_by_name)
      elsif response == 2
        park_view(search_by_state)
      elsif response == 3
        park_view(search_by_type)
      elsif response == 4
        random_park
      elsif response == 5
        start_menu
      elsif response == 6
        goodbye
        return
      else
        puts
        puts "Invalid input" 
      end
      search_menu

    end

    # methods supporting start menu
    def sign_in
        puts "------------------------------------------------------------------------"
        puts "          SIGN IN"
        puts "------------------------------------------------------------------------"
        puts "Enter your name"
        name_response=gets.chomp.downcase
        puts "OK- pulling up your profile"
        acct=find_account(name_response)
        user_search_menu(acct)
    end

    def user_search_menu(curr_user)
      user_menu = ["Search by Name", "Search by State", "Search by Park Category", "Suprise Me", "Parks In My State", "View my Favorites", "Back to Start Menu", "Exit"]
      puts
      puts "------------------------------------------------------------------------"
      puts "          #{curr_user.name.upcase}'S SEARCH MENU"
      puts "------------------------------------------------------------------------"
      puts "Search for infomation about National Parks"
      puts "(Please select a number from the list)"
      puts
      api_communicator.printlist(user_menu)
      response = gets.chomp.to_i
      if response == 1
         park_view(search_by_name, curr_user)
      elsif response == 2
        park_view(search_by_state, curr_user)
      elsif response == 3
        park_view(search_by_type, curr_user)
      elsif response == 4
         random_park(curr_user)
         user_search_menu(curr_user)
      elsif response == 5
         park_view(parks_in_state(curr_user.state), curr_user)
      elsif response == 6
        if favecheck(curr_user)
            #if favecheck (a test to see if list of favorites has at least 1 entry) returns true
            #view their favorites and select one 
            #this is getting the one park they select from their favorites and viewing it w/ a special method(favorite view- that won't re-prompt them to add it to favorties)
            favorite_view(self.api_communicator.query_park(array_selector(curr_user.list_favorites)),curr_user)
        else 
            #they have no favorites if they get to this point- then re-sends them to user menu 
            puts "You have no favorites!  You need to add some!"
            user_search_menu(curr_user)
        end
      elsif response == 7
        start_menu
      elsif response == 8
        goodbye
        return
      else
        puts "Invalid input"
      end
      user_search_menu(curr_user)
    end

    def favorite_view (curr_park, curr_user)
        mountain_art
        puts "------------------------------------------------------------------------"
        puts "          #{curr_park.name.upcase}"
        puts "------------------------------------------------------------------------"
        puts curr_park
        user_search_menu(curr_user)
    end

    def random_park(curr_user=nil)
      park_view(self.api_communicator.surprising_park, curr_user)
    end

    def favecheck(curr_user)
      curr_user.list_favorites.length>0
    end

    def create_account
        puts "------------------------------------------------------------------------"
        puts "          CREATE ACCOUNT"
        puts "------------------------------------------------------------------------"
        puts "Enter your name"
    
        name=gets.chomp.capitalize
        make_acct(name)
    end

    def make_acct(name)
        puts "Please enter state code of where you live (ie 'WA', 'OR')"
        #loop
        response=gets.chomp.upcase
        state=state_code_check(response)
        state_row=self.api_communicator.query_state(state)
        acct=User.find_or_create_by(name: name)
        state_row.users << acct
        puts "Acct Creation Succesful"
        acct
        
    end

    def state_code_check(code)
        valid=false
        abbreviations=State.all.map do |s|
            s.abbreviation
        end
        while !valid
            if abbreviations.include?(code.upcase)
                valid=true    
            else 
                puts "Invalid code- please re-enter"
                code=gets.chomp.upcase
            end
        end
        code.upcase
    end
    

    def find_account (name)
        users=usernames
        if (users.include?(name))
            a= User.find_by(name: name.capitalize)
            return a
        else
            puts "Couldn't find you!- please try again- or press 2 to create acct"
            response=gets.chomp.downcase
            if response.to_i==2
                user_search_menu(create_account)
            else
                find_account(response)
            end
        end
    end

    # Returns all usernames
    def usernames
        User.all.map do |u|
            u.name.downcase
        end.uniq
    end

    def park_view (curr_park, curr_user=nil)
        mountain_art
        puts "------------------------------------------------------------------------"
        puts "          #{curr_park.name.upcase}"
        puts "------------------------------------------------------------------------"
        puts curr_park

        if curr_user
            prompt_for_favorite(curr_park, curr_user)
        else
            puts 
            puts " *** Sign in to be able to save favorite parks!"
            puts "------------------------------------------------------------------------"
        end
    end
  

    def prompt_for_favorite(curr_park, curr_user)
      puts "Would you like to add this location to your favorites? (y/n)"
      response=gets.chomp.downcase
      if response== 'y' || response=='yes'
        curr_user.add_favorite(curr_park)
      else
        puts
        puts "Ok you can always favorite another time!"
      end
      user_search_menu(curr_user)

    end

    def search_by_name
        puts "Please enter the name of a national park"
        response=gets.chomp
        results=self.api_communicator.lenient_name_search(response)
        self.api_communicator.query_park(array_selector(results))
    end

    def parks_in_state(state)
        states_parks=state.parks.map { |e| e.name }
        self.api_communicator.query_park(array_selector(states_parks))
    end

    def search_by_state
        puts "Please enter a state"
        response=gets.chomp
        results=self.api_communicator.lenient_state_search(response)
        curr_state=self.api_communicator.query_state(array_selector(results))
        parks_in_state(curr_state)
    end

    def search_by_type
        puts "Please select a type of park from below"
        types=['National Park', 'Historic', 'Monument', 'Preserve', 'Memorial', 'River', 'Battlefield', 'Trail', 'Recreation']
        response=array_selector(types)
        results=self.api_communicator.lenient_type_search(response)
        self.api_communicator.query_park(array_selector(results))
    end

    def array_selector(arr)
        api_communicator.printlist(arr)
        puts "Pick a number to confirm selection"
        num = gets.chomp.to_i
        selection=arr[num-1]
        puts "You've chosen #{selection}"
        puts
        selection
    end

end
