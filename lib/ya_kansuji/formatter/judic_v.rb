# Simple kansuji formatter
module YaKansuji
  module Formatter
    # Formatter for Jpanese judicial style kansuji (kanji numerals version)
    module JudicV
      module_function

      def call(num, _options = {})
        return '〇' if num.zero?

        ret = ''
        head = true
        (UNIT_EXP4.reverse + ['']).each_with_index do |unit4, ridx4|
          i4 = (num / (10_000**(UNIT_EXP4.size - ridx4))).to_i % 10_000
          next if i4.zero?

          if head
            ret << (i4.to_s + unit4)
          else
            ret << (('%04d' % i4) + unit4)
          end
          head = false
        end
        ret.tr('0-9', '〇一二三四五六七八九')
      end
      YaKansuji.register_formatter :judic_v, self
    end
  end
end
