module YaKansuji
  module Formatter
    # Formatter for Japan government-style kansuji
    module Gov
      module_function

      def call(num, _options = {})
        return '0' if num.zero?

        parts = []
        (UNIT_EXP4.reverse + ['']).each_with_index do |unit4, ridx4|
          i4 = (num / (10_000**(UNIT_EXP4.size - ridx4))).to_i % 10_000
          next if i4.zero?

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
