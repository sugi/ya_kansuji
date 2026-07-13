# Simple kansuji formatter
module YaKansuji
  module Formatter
    # Formatter for Jpanese lawyer style kansuji
    module Lawyer
      module_function

      def call(num, _options = {})
        return '0' if num.zero?

        ret = ''
        chunks = Formatter.split_by_unit4(num)
        (chunks.size - 1).downto(0) do |idx4|
          i4 = chunks[idx4]
          next if i4.zero?

          unit4 = Formatter::UNIT4_UNITS[idx4]
          if i4 == 1
            ret << "1#{unit4}"
            next
          end

          ret << ((i4 >= 1000 ? "#{i4.to_s[0]},#{i4.to_s[1..-1]}" : i4.to_s) + unit4)
        end
        ret
      end
      YaKansuji.register_formatter :lawyer, self
    end
  end
end
