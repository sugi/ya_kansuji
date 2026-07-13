# frozen_string_literal: true

module YaKansuji
  module Formatter
    # Simple kansuji formatter
    module Simple
      DIGITS = %w(一 二 三 四 五 六 七 八 九).freeze
      UNITS = ([''] + UNIT_EXP3).freeze

      module_function

      def call(num, _options = {})
        return '零' if num.zero?

        ret = nil
        chunks = Formatter.split_by_unit4(num)
        (chunks.size - 1).downto(0) do |idx4|
          i4 = chunks[idx4]
          next if i4.zero?

          ret ||= ''.dup
          unit4 = Formatter::UNIT4_UNITS[idx4]
          if i4 == 1
            ret << '一' << unit4
            next
          end

          divisor = 1000
          3.downto(0) do |idx3|
            i3 = (i4 / divisor) % 10
            divisor /= 10
            next if i3.zero?

            unit3 = UNITS[idx3]
            if i3 == 1 && !unit3.empty?
              ret << unit3
            else
              ret << DIGITS[i3 - 1] << unit3
            end
          end
          ret << unit4
        end
        ret || ''
      end
      YaKansuji.register_formatter :simple, self
    end
  end
end
