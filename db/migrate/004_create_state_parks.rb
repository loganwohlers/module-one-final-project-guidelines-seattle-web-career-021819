class CreateStateParks < ActiveRecord::Migration[5.2]
    def change
        create_table :state_parks do |t|
            t.integer :state_id
            t.integer :park_id
        end
    end
end