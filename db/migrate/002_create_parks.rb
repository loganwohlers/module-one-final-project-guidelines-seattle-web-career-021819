class CreateParks < ActiveRecord::Migration[5.2]
    def change
        create_table :parks do |t|
            t.string :name
            t.string :designation
            t.string :description
            t.string :nps_ref
            t.string :url
            t.string :weather
        end
    end
end