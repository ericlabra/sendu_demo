class CreatePokemons < ActiveRecord::Migration[5.2]
  def change
    create_table :pokemons do |t|
      t.string :name, null: false, unique: true
      t.integer :weight, null: false
      t.integer :height, null: false

      t.timestamps
    end
  end
end
