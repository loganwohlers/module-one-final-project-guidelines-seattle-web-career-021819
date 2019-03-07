require_relative "../config/environment.rb"


class API
    @@state_code_conversion = YAML.load_file('state_codes.yml')
    KEY=NPS_API_KEY #USER ENTERS Key saved from bash profile
    BASE_URL='nps.gov/api/v1'

    #helper method to print out any array as a numbered list
    def printlist(arr)
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
    def all_states(arr)
        states=[]
        arr.each do |p|
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
    def state_parks(arr)
        arr.each do |p|
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

    def all_park_names
        Park.all.map { |park| park.name }
    end

    def all_state_names
        names=State.all.map { |state| state.full_name }
    end

    def all_park_categories
        categories=Park.all.map { |park| park.designation }.uniq.sort
    end

    #park name
    def lenient_name_search(name)
        any_results=false
        while !any_results
            results=all_park_names.select do |n|
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

    
    def lenient_state_search(name)
        any_results=false
        while !any_results
            results= @@state_code_conversion.select do |k,v|
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
    def lenient_type_search(name)
        any_results=false
        while !any_results
            results=all_parks.select do |park|
                park['designation'].downcase.include?(name.downcase)
            end
            if results.length>0
                any_results=true
            else
                puts "No results! Please try another search"
                name = gets.chomp
            end
        end
     results.map { |p| p['fullName']}
    end
end


