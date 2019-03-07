require_relative "../config/environment.rb"
# state_code_conversion = YAML.load_file('state_codes.yml')
class API
    KEY=NPS_API_KEY #USER ENTERS Key saved from bash profile
    BASE_URL='nps.gov/api/v1'

    #helper method to print out any array as a numbered list
    def printlist (arr)
        arr.each_with_index do |h, index|
            puts "#{index+1}. #{h}"
        end
    end

    #Goes into API- and grabs data for ALL parks and returns them as an array of hashes
    def all_parks
        response_string = RestClient.get('https://' + KEY + '@developer.' + BASE_URL + '/parks?limit=1000')
        query_hash_to_array(response_string)
    end

    #JSON parse the the RestClient response to URL and then return value of the 'data' key-- an array of hashes for each item(park)
    def query_hash_to_array (rest_client_response)
        JSON.parse(rest_client_response)['data']
    end

    #goes through
    def all_states
        states=[]
        all_parks.each do |p|
            if p['states'].length>2
                plural=p['states'].split(",")
                plural.each do |pl|
                    states << pl
                end
            else
                states << p['states']
            end
        end
        states.uniq!.sort
    end
    # def all_states_yaml
    #     state_code_conversion.values
    # end

    #Going thru all parks- looking at their state(s) in the api and then creating all StatePark associations
    def state_parks
        all_parks.each do |p|
            this_park = query_park(p["fullName"])
            if p['states'].length > 2
                multi=p['states'].split(",")
                multi.each do |state|
                    this_state = query_state(state)
                    sp=StatePark.create
                    this_state.state_parks << sp
                    this_park.state_parks << sp
                end
            else
            # grab state and park object and assigning to new variable
                this_state = query_state(p["states"])
                sp=StatePark.create
                this_state.state_parks << sp
                this_park.state_parks << sp
            end
        end
    end

    def query_state(state)
        State.find_by(abbreviation: state)
    end

    def query_park(park)
        Park.find_by(name: park)
    end
end
