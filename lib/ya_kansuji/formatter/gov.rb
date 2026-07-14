# frozen_string_literal: true

module YaKansuji
  module Formatter
    # Formatter for Japan government-style kansuji
    module Gov
      module_function

      def call(num, _options = {})
        int, frac = Formatter.split_fraction(num)
        frac.empty? ? frac_part = nil : frac_part = ".#{frac.join}"
        return frac_part ? "0#{frac_part}" : '0' if int.zero?

        parts = []
        chunks = Formatter.split_by_unit4(int)
        (chunks.size - 1).downto(0) do |idx4|
          i4 = chunks[idx4]
          next if i4.zero? && !(idx4.zero? && frac_part)

          unit4 = Formatter::UNIT4_UNITS[idx4]
          if i4 == 1
            parts << "1#{unit4}"
            next
          end
          parts << (i4.to_s + unit4)
        end
        ret = parts.join(', ')
        ret << frac_part if frac_part
        ret
      end
    end
    YaKansuji.register_formatter :gov, Formatter::Gov
  end
end
