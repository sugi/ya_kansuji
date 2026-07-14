# frozen_string_literal: true

# Simple kansuji formatter
module YaKansuji
  module Formatter
    # Formatter for Jpanese judicial style kansuji (kanji numerals version)
    module JudicV
      module_function

      def call(num, _options = {})
        int, frac = Formatter.split_fraction(num)
        return '〇' if int.zero? && frac.empty?

        ret = +''
        head = true
        chunks = Formatter.split_by_unit4(int)
        (chunks.size - 1).downto(0) do |idx4|
          i4 = chunks[idx4]
          next if i4.zero? && !(idx4.zero? && !frac.empty?)

          unit4 = Formatter::UNIT4_UNITS[idx4]
          if head
            ret << (i4.to_s + unit4)
          else
            ret << (('%04d' % i4) + unit4)
          end
          head = false
        end
        ret << '・' << frac.join unless frac.empty?
        ret.tr('0-9', '〇一二三四五六七八九')
      end
      YaKansuji.register_formatter :judic_v, self
    end
  end
end
