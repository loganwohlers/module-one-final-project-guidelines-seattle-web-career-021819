class User < ActiveRecord::Base
    belongs_to :state
    has_many :favorites
    has_many :parks, through: :favorites

    #user can add favorites (based on which park they are looking at/choose)
    def add_favorite(park)
        #what happens when they try to dupe favorites
        fave=Favorite.create
        self.favorites << fave
        park.favorites << fave
    end

    def search
      all_park_names
    end
 end
