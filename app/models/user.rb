class User < ActiveRecord::Base
    belongs_to :state
    has_many :favorites
    has_many :parks, through: :favorites
 end