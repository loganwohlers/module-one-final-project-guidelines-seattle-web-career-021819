class CLI
  attr_reader :api_communicator
  attr_accessor :current_user

  def initialize (api_communicator)
    @api_communicator=api_communicator # connects to API class
    @current_user=nil
  end

  ################# helper methods for class as a whole ########################

  def display_heading(text)
    puts <<~HEADING

    ------------------------------------------------------------------------
    #{text.upcase.center(72)}
    ------------------------------------------------------------------------
    HEADING
  end

  #helper method to print out any array as a numbered list
  def printlist(arr)
    arr.each_with_index do |h, index|
      puts "#{index+1}. #{h}"
    end
  end

  def array_selector(arr)
    printlist(arr)
    # TODO: display a message if input is invalid
    puts "Pick a number to confirm selection"
    num = gets.chomp.to_i
    selection=arr[num-1]
    puts "You've chosen #{selection}"
    puts
    selection
  end

  ########## methods invoked by run: welcome, start_menu, and goodbye ##########

  def welcome
    Art.greeting_message
  end

  def start_menu
    start_menu_keep_going = true
    while start_menu_keep_going

      display_heading("start menu")
      puts <<~START_MENU
      What would you like to do?
      Creating an account lets you save your favorite parks
      (Please select a number from the list)

      START_MENU

      start_menu_items = [
        "Sign In",
        "Create Account",
        "Search without Account",
        "Exit"
      ]
      printlist(start_menu_items)

      response = gets.chomp.to_i
      while !response.between?(1,4)
        puts "Please select a valid option:"
        printlist(start_menu_items)
        response = gets.chomp.to_i
      end

      case response
      when 1
        sign_in
        start_menu_keep_going = user_search_menu
      when 2
        create_account
        start_menu_keep_going = user_search_menu
      when 3
        self.current_user = nil
        start_menu_keep_going = search_menu
      when 4
        start_menu_keep_going = false
      end
    end
  end

  def goodbye
    Art.goodbye_message
  end

  ################# methods for signing in and signing up ######################

  def sign_in
    display_heading("sign in")
    puts "Enter your name"
    name_response=gets.chomp.downcase
    puts "OK- pulling up your profile"
    find_account(name_response)
  end

  def find_account(name)
    find_account_keep_going = true

    while find_account_keep_going
      if User.where(name: name.capitalize).exists?
        self.current_user = User.find_by(name: name.capitalize)
        find_account_keep_going = false
      else
        puts "Couldn't find you!- please try again- or press 2 to create acct"
        name=gets.chomp.downcase
        if name.to_i==2
          create_account
          find_account_keep_going = false
        end
      end
    end

  end

  def create_account
    display_heading("create account")
    puts "Enter your name"

    name=gets.chomp.capitalize
    make_acct(name)
  end

  def make_acct(name)
    puts "Please enter state code of where you live (ie 'WA', 'OR')"
    response=gets.chomp.upcase

    state=state_code_check(response)
    user = User.create(name: name, state: state)
    self.current_user = user

    puts "Acct Creation Succesful"
  end

  def state_code_check(code)
    state_code_check_keep_going = true
    while state_code_check_keep_going
      if State.where(abbreviation: code).exists?
        state_code_check_keep_going = false
      else
        puts "Invalid code- please re-enter"
        code=gets.chomp.upcase
      end
    end
    State.find_by(abbreviation: code)
  end

  ##################### search menu for signed in user #########################

  def user_search_menu
    user_search_menu_keep_going = true
    start_menu_keep_going = true

    while user_search_menu_keep_going

      display_heading("#{self.current_user.name}'s search menu")
      puts <<~SEARCH_MENU
      Search for infomation about National Parks
      (Please select a number from the list)

      SEARCH_MENU

      user_menu_items = [
        "Search by Name",
        "Search by State",
        "Search by Park Category",
        "Suprise Me",
        "Parks In My State",
        "View my Favorites",
        "Back to Start Menu",
        "Exit"
      ]
      printlist(user_menu_items)

      response = gets.chomp.to_i
      while !response.between?(1,8)
        puts "Please select a valid option:"
        printlist(user_menu_items)
        response = gets.chomp.to_i
      end

      case response
      when 1
        park = search_by_name
        park_view(park)
      when 2
        park = search_by_state
        park_view(park)
      when 3
        park = search_by_type
        park_view(park)
      when 4
        park = random_park
        park_view(park)
      when 5
        park = parks_in_state(self.current_user.state)
        park_view(park)
      when 6
        if favecheck
          park = DBCommunicator.query_park(array_selector(self.current_user.list_favorites))
          favorite_view(park)
        else
          puts "You have no favorites!  You need to add some!"
        end
      when 7
        user_search_menu_keep_going = false
      when 8
        user_search_menu_keep_going = false
        start_menu_keep_going = false
      end

    end

    start_menu_keep_going
  end

  ################# search menu when user is not signed in #####################

  def search_menu
    search_menu_keep_going = true
    start_menu_keep_going = true

    while search_menu_keep_going

      display_heading("search menu")
      puts <<~SEARCH_MENU
      Search for infomation about National Parks
      (Please select a number from the list)

      SEARCH_MENU

      search_menu_items = [
        "Search by Name",
        "Search by State",
        "Search by Park Category",
        "Suprise Me",
        "Back to Start Menu",
        "Exit"
      ]
      printlist(search_menu_items)

      response = gets.chomp.to_i
      while !response.between?(1,6)
        puts "Please select a valid option:"
        printlist(search_menu_items)
        response = gets.chomp.to_i
      end

      case response
      when 1
        park = search_by_name
        park_view(park)
      when 2
        park = search_by_state
        park_view(park)
      when 3
        park = search_by_type
        park_view(park)
      when 4
        park = random_park
        park_view(random_park)
      when 5
        search_menu_keep_going = false
      when 6
        search_menu_keep_going = false
        start_menu_keep_going = false
      end

    end

    start_menu_keep_going
  end

  #################### search helper methods ###################################

  def search_by_name
    puts "Please enter the name of a national park"
    response=gets.chomp
    results=DBCommunicator.lenient_name_search(response)
    DBCommunicator.query_park(array_selector(results))
  end

  def search_by_state
    puts "Please enter a state"
    response=gets.chomp
    results=DBCommunicator.lenient_state_search(response)
    curr_state=DBCommunicator.query_state(array_selector(results))
    parks_in_state(curr_state)
  end

  def parks_in_state(state)
    states_parks=state.parks.map { |e| e.name }
    DBCommunicator.query_park(array_selector(states_parks))
  end

  def search_by_type
    puts "Please select a type of park from below"
    types=['National Park', 'Historic', 'Monument', 'Preserve', 'Memorial', 'River', 'Battlefield', 'Trail', 'Recreation']
    response=array_selector(types)
    results=DBCommunicator.lenient_type_search(response)
    DBCommunicator.query_park(array_selector(results))
  end

  def random_park
    DBCommunicator.surprising_park
  end

  def favecheck
    !self.current_user.favorites.empty?
  end

  def favorite_view(curr_park)
    Art.mountain_art
    display_heading(curr_park.name)
    puts curr_park
  end

  def park_view(curr_park)
    Art.mountain_art
    display_heading(curr_park.name)
    puts curr_park

    if !self.current_user.nil?
      prompt_for_favorite(curr_park)
    else
      puts
      puts " *** Sign in to be able to save favorite parks!"
      puts "------------------------------------------------------------------------"
    end
  end

  def prompt_for_favorite(curr_park)
    puts "Would you like to add this location to your favorites? (y/n)"
    response=gets.chomp.downcase
    if response== 'y' || response=='yes'
      self.current_user.add_favorite(curr_park)
    else
      puts
      puts "Ok you can always favorite another time!"
    end
  end

end
