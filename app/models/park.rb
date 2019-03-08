class Park < ActiveRecord::Base
    has_many :favorites
    has_many :users, through: :favorites
    has_many :state_parks
    has_many :states, through: :state_parks


    def to_s
      "\nDESIGNATION: #{self.designation}\n\nDESCRIPTION: #{self.description}\n\nWEATHER: #{self.weather}\n\nURL: #{self.url}"
    end
end
