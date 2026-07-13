# frozen_string_literal: true

module YaKansuji
  module Formatter
    # Formatter for Japan government-style kansuji
    module Gov
      module_function

      def call(num, _options = {})
        return '0' if num.zero?

        parts = []
        chunks = Formatter.split_by_unit4(num)
        (chunks.size - 1).downto(0) do |idx4|
          i4 = chunks[idx4]
          next if i4.zero?

          unit4 = Formatter::UNIT4_UNITS[idx4]
          if i4 == 1
            parts << "1#{unit4}"
            next
          end
          parts << (i4.to_s + unit4)
        end
        parts.join(', ')
      end
    end
    YaKansuji.register_formatter :gov, Formatter::Gov
  end
end
