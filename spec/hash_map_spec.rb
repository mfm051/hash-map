# frozen_string_literal: true

require_relative '../lib/hash_map'

describe HashMap do
  describe '#hash' do
    subject(:hash_map) { described_class.new }
    
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

  describe '#set' do
    context 'when key is not present' do
      subject(:hash_map) { described_class.new }
      
      it 'creates a new node' do
        buckets = hash_map.instance_variable_get(:@buckets)

        expect { hash_map.set('test', 1) }.to change { buckets.compact.size }.by(1)
      end
    end

    context 'when key is already present' do
      subject(:hash_map_one_node) { described_class.new }

      before { hash_map_one_node.set('test', 1) }

      it 'changes value of the node' do
        buckets = hash_map_one_node.instance_variable_get(:@buckets)

        expect { hash_map_one_node.set('test', 2) }.to change { buckets.compact[0].value }.from(1).to(2)
      end
    end
  end

  describe '#get' do
    subject(:hash_map) { described_class.new }

    context 'when key is present' do
      before { hash_map.set('test', 1) }
 
      it 'returns value of given key' do
        value = hash_map.get('test')

        expect(value).to eq(1) 
      end
    end

    context 'when key is not present' do
      it 'returns nil' do
        nil_value = hash_map.get('nonexistent_key')

        expect(nil_value).to be_nil 
      end
    end
  end

  describe '#key?' do
    subject(:hash_map) { described_class.new }

    context 'when key is present in hash_map' do
      before { hash_map.set('test', 1) }

      it 'returns true' do
        existent_key = 'test'

        expect(hash_map.key?(existent_key)).to be true
      end
    end

    context 'when key is not present in hash_map' do
      it 'returns false' do
        nonexistent_key = 'another_test'

        expect(hash_map.key?(nonexistent_key)).to be false
      end
    end
  end

  describe 'remove' do
    subject(:hash_map) { described_class.new }

    before { hash_map.set('remove_me', 1) }
   
    let(:occupied_buckets_size) { hash_map.instance_variable_get(:@buckets).compact.size }
    
    context 'when key is present' do
      it 'removes node' do
        hash_map.remove('remove_me')

        expect(occupied_buckets_size).to be_zero
      end
    end

    context 'when key is not present' do
      it 'does not change present nodes' do
        hash_map.remove('not present')

        expect(occupied_buckets_size).to eq(1) 
      end
    end
  end
end
