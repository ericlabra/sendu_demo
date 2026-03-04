# frozen_string_literal: true

require 'rails_helper'

# The Search concern is tested through Pokemon, the only model that includes it.
RSpec.describe Search, type: :model do
  let(:pikachu_attrs) { { name: 'pikachu', weight: 60, height: 4 } }

  describe '.find_by_name' do
    let!(:pikachu) { Pokemon.create!(pikachu_attrs) }
    let!(:raichu)  { Pokemon.create!(name: 'raichu', weight: 300, height: 8) }

    it 'includes the matched record' do
      expect(Pokemon.find_by_name('pikachu')).to include(pikachu)
    end

    it 'excludes non-matching records' do
      expect(Pokemon.find_by_name('pikachu')).not_to include(raichu)
    end

    it 'is case-insensitive' do
      expect(Pokemon.find_by_name('PIKACHU')).to include(pikachu)
    end

    it 'supports partial matches – pikachu' do
      expect(Pokemon.find_by_name('chu')).to include(pikachu)
    end

    it 'supports partial matches – raichu' do
      expect(Pokemon.find_by_name('chu')).to include(raichu)
    end

    it 'returns an empty collection when nothing matches' do
      expect(Pokemon.find_by_name('mewtwo')).to be_empty
    end
  end

  describe '.request_pokemon_api' do
    context 'when the API responds successfully' do
      before do
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/squirtle')
          .to_return(
            status: 200,
            body: { name: 'squirtle', height: 5, weight: 90 }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      subject { Pokemon.request_pokemon_api('squirtle') }

      it { is_expected.to be_a(Hash) }

      it 'returns the correct name' do
        expect(subject[:name]).to eq('squirtle')
      end

      it 'returns the correct height' do
        expect(subject[:height]).to eq(5)
      end

      it 'returns the correct weight' do
        expect(subject[:weight]).to eq(90)
      end
    end

    context 'when the query is uppercased' do
      before do
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/Squirtle')
          .to_return(
            status: 200,
            body: { name: 'Squirtle', height: 5, weight: 90 }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'downcases the name in the returned hash' do
        expect(Pokemon.request_pokemon_api('Squirtle')[:name]).to eq('squirtle')
      end
    end

    context 'when the API responds with a failure' do
      before do
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/fakemon')
          .to_return(status: 404, body: 'Not found')
      end

      it 'raises a StandardError with a descriptive message' do
        expect { Pokemon.request_pokemon_api('fakemon') }
          .to raise_error(StandardError, 'Pokemon fakemon not found')
      end
    end
  end
end
