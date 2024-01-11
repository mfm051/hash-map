# frozen_string_literal: true

require_relative 'node'

class HashMap
  PRIME_NUMBER = 31

  def initialize
    @buckets = Array.new(16)
  end

  def hash(string)
    raise ArgumentError, "Hash limited to string" unless string.is_a?(String)

    raw_hash = string.chars.inject(0) { |sum, char| sum * PRIME_NUMBER + char.ord }

    raw_hash % @buckets.size
  end

  def set(key, value)
    index = hash(key)

    raise IndexError if index.negative? || index >= @buckets.length

    if @buckets[index].nil?
      @buckets[index] = Node.new(key, value)
    else
      @buckets[index].value = value
    end
  end
end
