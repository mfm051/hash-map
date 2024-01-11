# frozen_string_literal: true

require_relative '../lib/hash_map'

describe HashMap do
  subject(:hash_map) { described_class.new }
  
  describe '#hash' do
    context 'when argument is not a string' do
      it 'raises an error' do
        not_str = 2

        expect { hash_map.hash(not_str) }.to raise_error(ArgumentError)
      end
    end

    context 'when argument is a string' do
      let(:max_index)  { hash_map.instance_variable_get(:@buckets).size - 1 }
      
      matcher :be_a_hash do
        match { |num| num.is_a?(Integer) && num.between?(0, max_index) }
      end

      it 'returns an integer ' do
        not_hashed = 'a'

        hashed = hash_map.hash(not_hashed)

        expect(hashed).to be_a_hash
      end

      it 'returns same integer for same argument' do
        value_1 = 'a'
        value_2 = 'a'

        hashed_1 = hash_map.hash(value_1)
        hashed_2 = hash_map.hash(value_2)

        expect(hashed_1).to eq(hashed_2)
      end

      it 'returns different integer for different argument' do
        value_1 = 'a'
        value_2 = 'b'

        hashed_1 = hash_map.hash(value_1)
        hashed_2 = hash_map.hash(value_2)

        expect(hashed_1).not_to eq(hashed_2)
      end
    end
  end
end
