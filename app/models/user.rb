class User < ActiveRecord::Base
    belongs_to :state
    has_many :favorites
    has_many :parks, through: :favorites

    #user can add favorites (based on which park they are looking at/choose)
    def add_favorite(park)
      Favorite.create(user: self, park: park)
    end

    def list_favorites
      self.parks.map do |park|
        park.name
      end
    end
 end
