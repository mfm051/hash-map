# frozen_string_literal: true

class Node
  attr_reader :key
  attr_accessor :value

  def initialize(key, value)
    @key = key
    @value = value
  end
end
