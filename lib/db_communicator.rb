module DBCommunicator

  STATE_CODE_CONVERSION = YAML.load_file('state_codes.yml')

  #finds state in the db by abbreviation
  def self.query_state(state)
    State.find_by(abbreviation: state)
  end

  #finds park in the db by abbreviation
  def self.query_park(park)
    Park.find_by(name: park)
  end

  def self.surprising_park
    Park.all.sample
  end

  def self.park_search_helper(field, query)
    any_results = false
    while !any_results
      results = Park.where("#{field} LIKE :query", query: "%#{query}%")
      if !results.empty?
        any_results = true
      else
        puts "No results! Please try another search"
        query = gets.chomp
      end
    end
    results.map { |park| park.name }
  end

  # returns an array of park names where the names approximately match the search query
  def self.lenient_name_search(query)
    self.park_search_helper("name", query)
  end

  # returns an array of park names where the designations approximately match the search query
  def self.lenient_type_search(query)
    self.park_search_helper("designation", query)
  end

  # returns an array of state arrays, where the first element is the full name
  # and the second element is the state code
  def self.lenient_state_search(name)
    any_results=false
    while !any_results
      results= STATE_CODE_CONVERSION.select do |k,v|
        k.downcase.include?(name.downcase) ||  v.downcase.include?(name.downcase)
      end.to_a
      if results.length>0
        any_results=true
      else
        puts "No results! Please try another search"
        name = gets.chomp
      end
    end
    results
  end

end
