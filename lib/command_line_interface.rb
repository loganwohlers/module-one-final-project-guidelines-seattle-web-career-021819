class CLI
    attr_reader :api_communicator
    @@start_menu = ["Sign In", "Create Account", "Search without Account", "Exit"]
    @@search_menu = ["Search by Name", "Search by State", "Search by Park Category", "Suprise Me", "Back to Start Menu", "Exit"]

    def initialize (api_communicator)
        @api_communicator=api_communicator # connects to API class

    end

    def welcome
        puts "Welcome to the National Park Database"
    end

    # MENUS
    def start_menu
      puts
      puts "------ START MENU ------"
      puts "What would you like to do?"
      puts "Creating an account lets you save your favorite parks"
      puts "(Please select a number from the list)"
      puts
      api_communicator.printlist(@@start_menu)
      response = gets.chomp.to_i

      if response == 1
        sign_in
      elsif response == 2
        create_account
      elsif response == 3
        search_menu
      elsif response == 4
        puts "Exit"
      else
        puts "Invalid input"
      end
    end

    def search_menu
      puts
      puts "------ SEARCH MENU ------"
      puts "Search for infomation about National Parks"
      puts "(Please select a number from the list)"
      puts
      api_communicator.printlist(@@search_menu)
      response = gets.chomp.to_i

      if response == 1
        search_by_name
      elsif response == 2
        create_account
      elsif response == 3
        search_menu
      elsif response == 4
        puts "Exit"
      else
        puts "Invalid input"
      end
    end

    # methods supporting start menu
    def sign_in
      puts "------ SIGN IN ------"
      puts "Enter your name"
      name_response=gets.chomp.downcase
      puts "OK- pulling up your profile"
      find_account (name_response)
    end

    def create_account
      puts "------ CREATE ACCOUNT ------"
      puts "Enter your name"
      name=gets.chomp.downcase
      make_acct(name)
    end

    def prompt
        puts "enter a state code"
        response=gets.chomp
    end

    def find_account (name)
        users=usernames
        if (users.include?(name))
            a= User.find_by(name: name.capitalize)
            p a
            return a
        else
            puts "Couldn't find you!"
        end
    end
    
    # Returns all usernames
    def usernames
        User.all.map do |u|
            u.name.downcase
        end.uniq
    end

    def make_acct(name)
        puts "Please enter state code of where you live (ie 'WA', 'OR')"
        state=gets.chomp.upcase
        state_row=self.api_communicator.query_state(state)
        acct=User.create(name: name)
        state_row.users << acct
        puts "Here is your profile:"
        p acct
    end

    def search_by_name 
        puts "Please enter the name of a national park"
        response=gets.chomp
        results=self.api_communicator.lenient_name_search(response)
        p self.api_communicator.query_park(array_selector(results))
    end

    def search_by_state 
        puts "Please enter a state"
        response=gets.chomp
        results=self.api_communicator.lenient_state_search(response)
        p self.api_communicator.query_state(array_selector(results))
    end

    def array_selector(arr)
        api_communicator.printlist(arr)
        puts "Pick a number to confirm selection"
        num = gets.chomp.to_i
        selection=arr[num-1]
        puts "You've chosen #{selection}"
        selection
    end

end
