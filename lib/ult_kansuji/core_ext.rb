require 'ult_kansuji'

class String
  def to_number
    UltKansuji.to_i self
  end
end

class Integer
  def to_kansuji
    UltKansuji.to_kan self
  end
end
