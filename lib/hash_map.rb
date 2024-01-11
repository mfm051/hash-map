# frozen_string_literal: true

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
end
