# frozen_string_literal: true

require_relative 'node'

class HashMap
  PRIME_NUMBER = 31

  def initialize
    @buckets = Array.new(16)
  end

  def hash(string)
    raise ArgumentError, 'Hash limited to string' unless string.is_a?(String)

    raw_hash = string.chars.inject(0) { |sum, char| sum * PRIME_NUMBER + char.ord }

    raw_hash % @buckets.size
  end

  def set(key, value)
    index = hash(key)

    raise IndexError if index.negative? || index >= @buckets.length

    @buckets[index] = Node.new(key, value)

    update_buckets if over_load_factor?
  end

  def get(key)
    @buckets[hash(key)]&.value
  end

  def key?(key)
    @buckets[hash(key)]&.key == key
  end

  def remove(key)
    return unless key?(key)

    @buckets[hash(key)] = nil
  end

  def length = @buckets.compact.size

  def clear
    @buckets = Array.new(@buckets.size)
  end

  def keys = @buckets.compact.map { |node| node.key }

  def values = @buckets.compact.map { |node| node.value }

  def entries = @buckets.compact.map { |node| [node.key, node.value] }

  private

  def update_buckets
    new_buckets = Array.new(@buckets.size * 2)

    @buckets.each_with_index { |node, i| new_buckets[i] = node }

    @buckets = new_buckets
  end

  def over_load_factor?
    (@buckets.compact.size / @buckets.size.to_f) >= 0.75
  end
end
