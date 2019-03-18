class API

  KEY=NPS_API_KEY #USER ENTERS Key saved from bash profile

  #Goes into API- and grabs data for ALL parks and returns them as an array of hashes
  def all_parks
    response_string = RestClient.get("https://developer.nps.gov/api/v1/parks?api_key=#{KEY}&limit=1000")
    query_hash_to_array(response_string)
  end

  #JSON parse the the RestClient response to URL and then return value of the 'data' key-- an array of hashes for each item(park)
  def query_hash_to_array(rest_client_response)
    array = JSON.parse(rest_client_response)['data']
    # this part is cleaning up mistakes made in the API backend
    # most of the data comes back encoded correctly, but in a couple cases there
    # are characters that are HTML encoded, e.g. "Haleakal&#257; National Park"
    # which should really be "Haleakalā National Park"
    array.map do |park_hash|
      park_hash.each do |key, value|
        park_hash[key] = Nokogiri::HTML.parse(value).content
      end
    end
  end

  # goes through an array of hashes; each hash contains the data for a park
  # returns a sorted array of all the state codes
  def all_states(park_hashes)
    states=[]
    park_hashes.each do |park_hash|
      states_str = park_hash["states"]
      states_list = states_str.split(",")
      # the union (|) method only adds elements of states_list that aren't already in states
      states = states | states_list
    end
    states.sort
  end

  #Going thru all parks- looking at their state(s) in the api and then creating all StatePark associations
  def state_parks(park_hashes)
    park_hashes.each do |park_hash|
      park = DBCommunicator.query_park(park_hash["fullName"])
      states_str = park_hash["states"]
      states_list = states_str.split(",")
      states_list.each do |state_code|
        state = DBCommunicator.query_state(state_code)
        park.states << state
      end
    end
  end

end
