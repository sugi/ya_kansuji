# frozen_string_literal: true

require 'ya_kansuji'

# Core extension by kansuji
class Integer
  def to_kan(formatter = :simple, options = {})
    YaKansuji.to_kan self, formatter, options
  end
end
