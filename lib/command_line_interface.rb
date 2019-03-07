class CLI  
    attr_reader :api_communicator

    def initialize (api_communicator)
        @api_communicator=api_communicator
    end

    def account 
        puts "Do you have an account?  (y/n)"
        response=gets.chomp.downcase
        if response=='y' || response=='yes'
            puts "Enter your name"
            name_response=gets.chomp.downcase
            puts "OK- pulling up your profile"
            find_account (name_response)
        else
            puts "No worries- we'll make one right now"
            puts "Enter your name"
            name=gets.chomp.downcase
            make_acct(name)
        end
    end

    def prompt
        puts "enter a state code"
        response=gets.chomp
    end

    def welcome
        puts "Welcome to the National Park Database"

    end

    def find_account (name)
        users=usernames
        if (users.include?(name))
            a= User.find_by(name: name.capitalize)
            p a
            return a
        else
            puts "Couldn't find you!"
        end
    end
    #         puts "You aren't in our system!!"
    #         puts "making you a profile now....created"
    #         new_user=User.create(title: response)
    #         return new_user
    #     end
    # end

    # Returns all usernames
    def usernames
        User.all.map do |u|
            u.name.downcase
        end.uniq
    end

    def make_acct(name)
        puts "Please enter your state code (ie 'WA', 'OR')"
        state=gets.chomp.upcase
        state_row=self.api_communicator.query_state(state)
        acct=User.create(name: name)
        state_row.users << acct
        p acct
    end



end