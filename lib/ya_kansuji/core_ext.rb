require 'ya_kansuji'

# Core extension by kansuji
class String
  def to_number
    YaKansuji.to_i self
  end

  def to_num
    YaKansuji.to_i self
  end
end

# Core extension by kansuji
class Integer
  def to_kansuji
    YaKansuji.to_kan self
  end

  def to_kan
    YaKansuji.to_kan self
  end
end
