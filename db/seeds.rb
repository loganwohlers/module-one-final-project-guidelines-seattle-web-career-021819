require_relative "../config/environment.rb"
api=API.new
state_code_conversion = YAML.load_file('state_codes.yml')

Favorite.destroy_all
Park.destroy_all
StatePark.destroy_all
State.destroy_all
User.destroy_all

# TODO: figure out if all of these really should be constants
#we call on our all_parks method once and save the resulting array as opposed to calling on the api multiple times
ALL_PARKS=api.all_parks

#creates an array of all states (by state code from the ALL_PARKS array data)
ALL_STATES=api.all_states(ALL_PARKS)

#seeds db w/ all national parks
ALL_PARKS.each do |park|
  Park.create(
    name: park["fullName"],
    designation: park["designation"],
    description: park["description"],
    nps_ref: park["id"],
    url: park["url"],
    weather: park["weatherInfo"]
  )
end

#seeds all of our states in the db using state codes (also adds state's full name via conversion from our yaml dictionary file
ALL_STATES.each do |state|
  State.create(abbreviation: state, full_name: state_code_conversion.key(state))
end

# TODO: figure out what this is doing
#Seeding all state/park join table via state_parks method from api_comm file
api.state_parks(ALL_PARKS)
