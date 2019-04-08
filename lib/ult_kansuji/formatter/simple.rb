module UltKansuji
  register_formatter :simple, lambda { |num, _options = {}|
    return '零' if num.zero?

    ret = ''
    (UNIT_EXP4.reverse + ['']).each_with_index do |unit4, ridx4|
      i4 = (num / 10_000**(UNIT_EXP4.size - ridx4)).to_i % 10_000
      next if i4.zero?

      if i4 == 1
        ret += "一#{unit4}"
        next
      end
      (UNIT_EXP3.reverse + ['']).each_with_index do |unit3, ridx3|
        i3 = (i4 / 10**(UNIT_EXP3.size - ridx3)).to_i % 10
        next if i3.zero?

        if i3 == 1 && unit3 != ''
          ret += unit3
        else
          ret += i3.to_s.tr('123456789', '一二三四五六七八九') + unit3
        end
      end
      ret += unit4
    end
    ret
  }
end
