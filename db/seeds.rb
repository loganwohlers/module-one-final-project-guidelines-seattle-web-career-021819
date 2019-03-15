require_relative "../config/environment.rb"
api=API.new
state_code_conversion = YAML.load_file('state_codes.yml')

Favorite.destroy_all
Park.destroy_all
StatePark.destroy_all
State.destroy_all
User.destroy_all

#we call on our all_parks method once and save the resulting array as opposed to calling on the api multiple times
all_parks=api.all_parks

#creates an array of all states (by state code from the ALL_PARKS array data)
all_states=api.all_states(all_parks)

#seeds db w/ all national parks
all_parks.each do |park_hash|
  Park.create(
    name: park_hash["fullName"],
    designation: park_hash["designation"],
    description: park_hash["description"],
    nps_ref: park_hash["id"],
    url: park_hash["url"],
    weather: park_hash["weatherInfo"]
  )
end

#seeds all of our states in the db using state codes (also adds state's full name via conversion from our yaml dictionary file
all_states.each do |state_code|
  State.create(abbreviation: state_code, full_name: state_code_conversion.key(state_code))
end

#Seeding all state/park join table via state_parks method from api_comm file
api.state_parks(all_parks)
