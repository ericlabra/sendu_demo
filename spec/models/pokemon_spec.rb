# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pokemon, type: :model do
  let(:pikachu_attrs) { { name: 'pikachu', weight: 60, height: 4 } }

  describe 'validations' do
    subject(:pokemon) { described_class.new(pikachu_attrs) }

    it { is_expected.to be_valid }

    context 'when name is blank' do
      before { pokemon.name = nil }

      it { is_expected.not_to be_valid }

      it 'reports the correct error on name' do
        pokemon.valid?
        expect(pokemon.errors[:name]).to include("can't be blank")
      end
    end

    context 'when weight is blank' do
      before { pokemon.weight = nil }

      it { is_expected.not_to be_valid }

      it 'reports the correct error on weight' do
        pokemon.valid?
        expect(pokemon.errors[:weight]).to include("can't be blank")
      end
    end

    context 'when height is blank' do
      before { pokemon.height = nil }

      it { is_expected.not_to be_valid }

      it 'reports the correct error on height' do
        pokemon.valid?
        expect(pokemon.errors[:height]).to include("can't be blank")
      end
    end

    context 'when a pokemon with the same name already exists' do
      let!(:_existing) { described_class.create!(pikachu_attrs) }

      it { is_expected.not_to be_valid }

      it 'reports the correct error on name' do
        pokemon.valid?
        expect(pokemon.errors[:name]).to include('has already been taken')
      end
    end
  end

  describe '.search' do
    context 'when the pokemon already exists in the database' do
      let!(:pikachu) { described_class.create!(pikachu_attrs) }

      subject { described_class.search('Pikachu') }

      it { is_expected.to eq(pikachu) }

      it 'does not call the external API' do
        expect(HTTParty).not_to receive(:get)
        described_class.search('Pikachu')
      end

      it 'is case-insensitive' do
        expect(described_class.search('PIKACHU')).to eq(pikachu)
      end
    end

    context 'when the pokemon does not exist in the database' do
      before do
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/bulbasaur')
          .to_return(
            status: 200,
            body: { name: 'bulbasaur', height: 7, weight: 69 }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      subject { described_class.search('Bulbasaur') }

      it { is_expected.to be_a(described_class) }
      it { is_expected.to be_persisted }

      it 'stores the name downcased' do
        expect(subject.name).to eq('bulbasaur')
      end

      it 'stores the weight from the API' do
        expect(subject.weight).to eq(69)
      end

      it 'stores the height from the API' do
        expect(subject.height).to eq(7)
      end
    end

    context 'when the API responds with an error' do
      before do
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/unknownpokemon')
          .to_return(status: 404, body: 'Not found')
      end

      it 'returns nil' do
        expect(described_class.search('unknownpokemon')).to be_nil
      end

      it 'does not raise an exception' do
        expect { described_class.search('unknownpokemon') }.not_to raise_error
      end
    end
  end

  describe '.save_pokemon' do
    context 'when the API responds successfully' do
      before do
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/charmander')
          .to_return(
            status: 200,
            body: { name: 'charmander', height: 6, weight: 85 }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      subject { described_class.save_pokemon('charmander') }

      it { is_expected.to be_a(described_class) }
      it { is_expected.to be_persisted }

      it 'stores the correct name' do
        expect(subject.name).to eq('charmander')
      end

      it 'stores the correct weight' do
        expect(subject.weight).to eq(85)
      end

      it 'stores the correct height' do
        expect(subject.height).to eq(6)
      end
    end

    context 'when the API responds with an error' do
      before do
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/notapokemon')
          .to_return(status: 404, body: 'Not found')
      end

      it 'returns nil' do
        expect(described_class.save_pokemon('notapokemon')).to be_nil
      end
    end
  end
end
