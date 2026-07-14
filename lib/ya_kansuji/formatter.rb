# frozen_string_literal: true

module YaKansuji
  # Shared helpers for built-in formatters.
  module Formatter
    UNIT4_BASE = 10_000
    UNIT4_CHUNK_LIMIT = UNIT_EXP4.size + 1
    UNIT4_UNITS = ([''] + UNIT_EXP4).freeze
    EMPTY_FRACTION = [].freeze

    module_function

    def split_by_unit4(num)
      chunks = []
      UNIT4_CHUNK_LIMIT.times do
        num, chunk = num.divmod(UNIT4_BASE)
        chunks << chunk
        break if num.zero?
      end
      chunks
    end

    def split_fraction(num)
      num = YaKansuji.normalize_value(num)
      return [num, EMPTY_FRACTION] if num.is_a?(Integer)

      int = num.truncate
      scaled = ((num - int) * FRAC_BASE).to_i
      digits = []
      UNIT_FRAC.size.times do
        scaled, d = scaled.divmod(10)
        digits.unshift(d) unless digits.empty? && d.zero?
      end
      [int, digits]
    end
  end
end
