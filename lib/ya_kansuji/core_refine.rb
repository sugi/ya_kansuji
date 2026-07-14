# frozen_string_literal: true

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
      def to_kan(formatter = :simple, options = {})
        YaKansuji.to_kan self, formatter, options
      end
    end

    refine Numeric do
      def to_kan(formatter = :simple, options = {})
        YaKansuji.to_kan self, formatter, options
      end
    end
  end
end

require 'ya_kansuji' unless YaKansuji.respond_to?(:to_i) && YaKansuji.respond_to?(:to_kan)
