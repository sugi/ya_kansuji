# frozen_string_literal: true

require 'ya_kansuji/version'

# Yet another Kansuji library for ruby.
module YaKansuji
  UNIT_EXP3 = %w(十 百 千).freeze
  UNIT_EXP4 = %w(万 億 兆 京 垓 𥝱 穣 溝 澗 正 載 極 恒河沙 阿僧祇 那由他 不可思議 無量大数).freeze
  MAX_VALUE = (10_000**(UNIT_EXP4.size + 1)) - 1
  UNIT_FRAC = %w(分 厘 毛 糸 忽 微 繊 沙 塵 埃 渺 漠
                 模糊 逡巡 須臾 瞬息 弾指 刹那 六徳 虚空 清浄).freeze
  FRAC_BASE = 10**UNIT_FRAC.size
  NUM_ALT_CHARS = '〇一二三四五六七八九０１２３４５６７８９零壱壹弌弐貳貮参參弎肆伍陸漆質柒捌玖拾什陌佰阡仟萬秭'
  NUM_NORMALIZED_CHARS = '01234567890123456789011122233345677789十十百百千千万𥝱'
  # rubocop:disable Lint/DuplicateRegexpCharacterClassElement
  REGEXP_PART = %r{
    [
      #{(NUM_ALT_CHARS + NUM_NORMALIZED_CHARS).chars.uniq.join}
      #{(UNIT_EXP3 + UNIT_EXP4).find_all { |u| u.length == 1 }.join}
      卄廿卅丗卌皕
    ] |
    #{UNIT_EXP4.find_all { |u| u.length > 1 }.join('|')}
  }x.freeze
  # rubocop:enable Lint/DuplicateRegexpCharacterClassElement
  REGEXP = /(?:マイナス)?(?:#{REGEXP_PART})+/.freeze
  @@formatters = {}

  module_function

  def to_i(str)
    str = str.to_s.tr(NUM_ALT_CHARS, NUM_NORMALIZED_CHARS)
    str.gsub!(/[,，、[:space:]]/, '')
    matched = REGEXP.match(str) or return 0
    ret3 = 0
    ret4 = 0
    curnum = nil
    if str.respond_to? :_to_i_ya_kansuji_orig
      to_i_meth = :_to_i_ya_kansuji_orig
    else
      to_i_meth = :to_i
    end
    matched[0].scan(REGEXP_PART).each do |c|
      case c
      when '1', '2', '3', '4', '5', '6', '7', '8', '9'
        if curnum
          curnum *= 10
        else
          curnum = 0
        end
        curnum += c.public_send(to_i_meth)
      when '0'
        curnum and curnum *= 10
      when '卄', '廿'
        ret3 += 20
        curnum = nil
      when '卅', '丗'
        ret3 += 30
        curnum = nil
      when '卌'
        ret3 += 40
        curnum = nil
      when '皕'
        ret3 += 200
        curnum = nil
      when *UNIT_EXP4
        if curnum
          ret3 += curnum
          curnum = nil
        end
        ret3 = 1 if ret3.zero?
        ret4 += ret3 * (10**((UNIT_EXP4.index(c) + 1) * 4))
        ret3 = 0
      when *UNIT_EXP3
        curnum ||= 1
        ret3 += curnum * (10**(UNIT_EXP3.index(c) + 1))
        curnum = nil
      end
    end
    if curnum
      ret3 += curnum
      curnum = nil
    end
    ret = ret4 + ret3
    matched[0].start_with?('マイナス') ? -ret : ret
  end

  def normalize_value(num)
    return num if num.is_a?(Integer)

    unless num.is_a?(Numeric)
      return num._to_i_ya_kansuji_orig if num.respond_to?(:_to_i_ya_kansuji_orig)

      return num.to_i
    end

    num = rational_from_float(num) if num.is_a?(Float)
    int = num.truncate
    scaled = ((num - int) * FRAC_BASE).round
    if scaled.abs >= FRAC_BASE
      if scaled.negative?
        int -= 1
      else
        int += 1
      end
      scaled = 0
    end
    scaled.zero? ? int : Rational((int * FRAC_BASE) + scaled, FRAC_BASE)
  end

  def rational_from_float(num)
    raise FloatDomainError, num.to_s if num.nan? || num.infinite?

    m = /\A(-?)(\d+)(?:\.(\d+))?(?:e([+-]?\d+))?\z/.match(num.to_s)
    raise FloatDomainError, num.to_s unless m

    ret = Rational(Integer(m[2] + (m[3] || ''), 10))
    ret = -ret unless m[1].empty?
    exp = (m[4] ? Integer(m[4], 10) : 0) - (m[3] ? m[3].size : 0)
    exp >= 0 ? ret * (10**exp) : ret / (10**-exp)
  end

  def register_formatter(sym, proc = nil, &block)
    if block_given?
      @@formatters[sym] = block
    elsif proc.respond_to? :call
      @@formatters[sym] = proc
    else
      raise ArgumentError, 'Registering invalid formatter.'
    end
  end

  def formatter(sym)
    @@formatters[sym]
  end

  def formatters
    @@formatters
  end

  def to_kan(num, formatter = :simple, options = {})
    num = normalize_value(num)
    if num.truncate.abs > MAX_VALUE
      raise RangeError, "Value must be between #{-MAX_VALUE} and #{MAX_VALUE}"
    end

    return "マイナス#{to_kan(-num, formatter, options)}" if num.negative?

    if formatter.respond_to? :call
      formatter.call num, options
    elsif @@formatters[formatter]
      @@formatters[formatter].call num, options
    else
      raise ArgumentError, "Unable to find formatter #{formatter}"
    end
  end
end

require 'ya_kansuji/formatter'
require 'ya_kansuji/formatter/simple'
require 'ya_kansuji/formatter/gov'
require 'ya_kansuji/formatter/lawyer'
require 'ya_kansuji/formatter/judic_v'
require 'ya_kansuji/formatter/judic_h'
require 'ya_kansuji/core_refine' unless defined?(YaKansuji::CoreRefine)
