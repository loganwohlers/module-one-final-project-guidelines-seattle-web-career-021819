def prompt
    puts "enter a state code"
    response=gets.chomp
end

def welcome
    puts "Welcome to the National Park Database"
end

def user_check
    users=usernames
    if (users.include?(response))
        puts "Looks like we've got you in our system!"
        a= User.all.find_by(title: response.capitalize)
        return a
    else
        puts "You aren't in our system!!"
        puts "making you a profile now....created"
        new_user=User.create(title: response)
        return new_user
    end
end

# Returns all usernames
def usernames
    User.all.map do |u|
        u.title.downcase
    end.uniq
end