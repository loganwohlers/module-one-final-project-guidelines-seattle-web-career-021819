class State < ActiveRecord::Base
    has_many :users
    has_many :state_parks
    has_many :parks, through: :state_parks
end