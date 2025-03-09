# frozen_string_literal: true

require 'ya_kansuji'

module YaKansuji
  # String and Integer refinements with YaKansuji
  module CoreRefine
    refine String do
      def to_i(base = nil)
        if base.nil? || base == :kan || base == :kansuji
          YaKansuji.to_i self
        else
          super
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
