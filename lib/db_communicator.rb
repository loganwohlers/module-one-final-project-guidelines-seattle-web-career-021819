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

  def self.all_park_names
    Park.all.map { |park| park.name }
  end

  def self.surprising_park
    parks=self.all_park_names
    self.query_park(parks.sample)
  end

  #park name
  # TODO: figure out why it says "park name"
  def self.lenient_name_search(name)
    any_results=false
    while !any_results
      results=self.all_park_names.select do |n|
        n.downcase.include?(name.downcase)
      end
      if results.length>0
        any_results=true
      else
        puts "No results! Please try another search"
        name = gets.chomp
      end
    end
    results
  end

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

  #park name
  # TODO: figure out why it says "park name"
  def self.lenient_type_search(name)
    any_results=false
    while !any_results
      results = Park.where("designation like :designation", designation: "%#{name}%")
      if results.length>0
        any_results=true
      else
        puts "No results! Please try another search"
        name = gets.chomp
      end
    end
    results.map { |p| p.name}
  end
end
