# frozen_string_literal: true

module YaKansuji
  # Shared helpers for built-in formatters.
  module Formatter
    UNIT4_BASE = 10_000
    UNIT4_CHUNK_LIMIT = UNIT_EXP4.size + 1
    UNIT4_UNITS = ([''] + UNIT_EXP4).freeze

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
  end
end
