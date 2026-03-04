class Pokemon < ApplicationRecord
  include Search

  validates :name, presence: true, uniqueness: true
  validates :weight, presence: true
  validates :height, presence: true

  def self.search(query)
    query = query.downcase
    find_by(name: query) || save_pokemon(query)
  end

  def self.save_pokemon(query)
    pokemon = request_pokemon_api(query)
    create!(pokemon)
  rescue StandardError => e
    puts "Error: #{e.message}"
    nil
  end
end
