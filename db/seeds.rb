require_relative "../config/environment.rb"
api=API.new
state_code_conversion = YAML.load_file('state_codes.yml')

#p testx.key("AK")

Favorite.destroy_all
Park.destroy_all
StatePark.destroy_all
State.destroy_all
User.destroy_all


#Iterates thru all 56 territories and creates a new state row in our db using state abbreviation- then grabs full name key using abbreviation
#as value from our yaml dictionary file
api.all_50_states.each do |state|
    State.create(abbreviation: state, full_name: state_code_conversion.key(state))
end

# #user
 u2 = User.create(name: "Ellen")

#currently creates a row for all 496 natl parks
#want to also create corresponding state parks join table
api.get_all_parks.each do |park|
    Park.create(
        name: park["fullName"],
        designation: park["designation"],
        description: park["description"],
        nps_ref: park["id"],
        url: park["url"],
        weather: park["weatherInfo"]
    )
end

api.state_parks

# #favorite
# f1 = Favorite.create(user_id: u2.id, park_id: denali.id)


# s1.users << u2

binding.pry
0
