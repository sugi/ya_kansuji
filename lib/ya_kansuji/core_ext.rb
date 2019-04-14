# frozen_string_literal: true

require 'ya_kansuji'

# Core extension by kansuji
class String
  alias_method :_to_i_ya_kansuji_orig, :to_i unless defined?(_to_i_ya_kansuji_orig)

  def to_i(base = nil)
    if base.nil? || base == :kan
      YaKansuji.to_i self
    else
      _to_i_ya_kansuji_orig(base)
    end
  end
end

# Core extension by kansuji
class Integer
  def to_kan
    YaKansuji.to_kan self
  end
end
