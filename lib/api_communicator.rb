class API
    KEY=NPS_API_KEY #USER ENTERS Key saved from bash profile

    BASE_URL='nps.gov/api/v1'

    #helper method to print out any array as a numbered list
    def printlist (arr)
        arr.each_with_index do |h, index|
            puts "#{index+1}. #{h}"
        end
    end

    #JSON parse the the RestClient response to URL and then return the 'data' array
    def query_hash_to_array (rest_client_response)
        JSON.parse(rest_client_response)['data']
    end

    # make the web request
    def get_parks_from_api(user_entered_state)
        #/parks?statecode=' is a query for parks using ?statecode=
        response_string = RestClient.get('https://' + KEY + '@developer.' + BASE_URL + '/parks?statecode='+user_entered_state)
        #['data'] on response_string returns an ARRAY of hashes that we can then work on
        response_arr = query_hash_to_array(response_string)
        park_names=full_names(response_arr)
        printlist(park_names)

    end

    #iterates thru response_hash(from JSON/user input) and maps JUST the park name and returns it
    def full_names (arr)
        arr.map do |h|
            h['fullName']
        end
    end

    def get_all_parks
        response_string = RestClient.get('https://' + KEY + '@developer.' + BASE_URL + '/parks?limit=1000')
        response_arr=query_hash_to_array(response_string)
        park_names=full_names(response_arr)
        #printlist(park_names)
        response_arr
    end

    def state_parks
        get_all_parks.each do |p|
            if p['states'].length > 2
                multi=p['states'].split(",")
                this_park = query_park(p["fullName"])
                # binding.pry
                multi.each do |state|
                    this_state = query_state(state)
                    StatePark.create(
                    state_id: this_state.id,
                    park_id: this_park.id
                    )
                end
            else
            # grab state and park object and assigning to new variable
                this_state = query_state(p["states"])
                this_park = query_park(p["fullName"])

                StatePark.create(
                state_id: this_state.id,
                park_id: this_park.id
                )
                # binding.pry
            end
        end
    end

    def query_state(state)
    State.find_by(abbreviation: state)
    end

    def query_park(park)
    Park.find_by(name: park)
    end

    def all_50_states
        states=[]
        get_all_parks.each do |p|
            if p['states'].length>2
                plural=p['states'].split(",")
                plural.each do |pl|
                    states << pl
                end
            else
                states << p['states']
            end
        end
        states=states.uniq!.sort
        #printlist(states)
    end
end
