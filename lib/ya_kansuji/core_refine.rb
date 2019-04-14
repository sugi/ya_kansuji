# frozen_string_literal: true

require 'ya_kansuji'

# String and Integer refinements with YaKansuji
module YaKansuji
  module CoreRefine
    refine String do
      alias_method :_to_i_ya_kansuji_orig, :to_i unless defined?(_to_i_ya_kansuji_orig)
      def to_i(base = nil)
        if base.nil? || base == :kan
          YaKansuji.to_i self
        else
          _to_i_ya_kansuji_orig(base)
        end
      end
    end

    refine Integer do
      def to_kan(formatter = :simple)
        YaKansuji.to_kan self, formatter
      end
    end
  end
end