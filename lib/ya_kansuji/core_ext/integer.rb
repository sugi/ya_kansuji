# frozen_string_literal: true

require 'ya_kansuji'

# Core extension by kansuji
class Integer
  def to_kan
    YaKansuji.to_kan self
  end
end
