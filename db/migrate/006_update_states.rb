class UpdateStates < ActiveRecord::Migration[5.2]
    def change
        rename_column :states, :name, :abbreviation
        add_column :states, :full_name, :string
    end
end
