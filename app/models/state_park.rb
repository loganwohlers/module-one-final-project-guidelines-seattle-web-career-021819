class StatePark < ActiveRecord::Base
   belongs_to :state
   belongs_to :park
end