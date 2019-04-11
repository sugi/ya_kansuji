require 'ya_kansuji'

class String
  def to_number
    YaKansuji.to_i self
  end
end

class Integer
  def to_kansuji
    YaKansuji.to_kan self
  end
end
