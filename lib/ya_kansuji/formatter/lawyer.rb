# Simple kansuji formatter
module YaKansuji
  module Formatter
    module Lawyer
      module_function

      def call(num, _options = {})
        return '0' if num.zero?

        ret = ''
        (UNIT_EXP4.reverse + ['']).each_with_index do |unit4, ridx4|
          i4 = (num / 10_000**(UNIT_EXP4.size - ridx4)).to_i % 10_000
          next if i4.zero?

          if i4 == 1
            ret << "1#{unit4}"
            next
          end

          ret << (i4 >= 1000 ? "#{i4.to_s[0]},#{i4.to_s[1..-1]}" : i4.to_s) + unit4
        end
        ret
      end
      YaKansuji.register_formatter :lawyer, self
    end
  end
end
