class Favorite < ActiveRecord::Base
    belongs_to :user
    belongs_to :park

    #def self.most_favorited
 end