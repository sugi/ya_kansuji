# frozen_string_literal: true

# Simple kansuji formatter
module YaKansuji
  module Formatter
    # Formatter for Jpanese lawyer style kansuji
    module Lawyer
      module_function

      def call(num, _options = {})
        int, frac = Formatter.split_fraction(num)
        frac.empty? ? frac_part = nil : frac_part = ".#{frac.join}"
        return frac_part ? "0#{frac_part}" : '0' if int.zero?

        ret = +''
        chunks = Formatter.split_by_unit4(int)
        (chunks.size - 1).downto(0) do |idx4|
          i4 = chunks[idx4]
          next if i4.zero? && !(idx4.zero? && frac_part)

          unit4 = Formatter::UNIT4_UNITS[idx4]
          if i4 == 1
            ret << "1#{unit4}"
            next
          end

          ret << ((i4 >= 1000 ? "#{i4.to_s[0]},#{i4.to_s[1..-1]}" : i4.to_s) + unit4)
        end
        ret << frac_part if frac_part
        ret
      end
      YaKansuji.register_formatter :lawyer, self
    end
  end
end
