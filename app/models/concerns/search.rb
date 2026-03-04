module Search
  extend ActiveSupport::Concern
  include HTTParty

  included do
    def self.find_by_name(query)
      query = query.downcase
      where("name LIKE ?", "%#{query}%")
    end

    def self.request_pokemon_api(query)
      response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{query}")

      if response.success?
        { height: response.dig('height'), weight: response.dig('weight'), name: query.downcase }
      else
        raise StandardError, "Pokemon #{query} not found"
      end
    end
  end
end