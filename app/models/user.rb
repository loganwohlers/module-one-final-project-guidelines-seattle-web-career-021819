class User < ActiveRecord::Base
    belongs_to :state
    has_many :favorites
    has_many :parks, through: :favorites

    #user can add favorites (based on which park they are looking at/choose)
    def add_favorite(park)
        Favorite.find_or_create_by(user_id: self.id, park_id: park.id)
    end

    def list_favorites
      self.favorites.map do |f|
        Park.find(f.park_id).name
      end
    end
 end
