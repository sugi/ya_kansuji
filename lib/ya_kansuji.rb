# frozen_string_literal: true

require 'ya_kansuji/version'
require 'ya_kansuji/core_refine'

# Yet another Kansuji library for ruby.
module YaKansuji
  UNIT_EXP3 = %w(十 百 千).freeze
  UNIT_EXP4 = %w(万 億 兆 京 垓 𥝱 穣 溝 澗 正 載 極 恒河沙 阿僧祇 那由他 不可思議 無量大数).freeze
  NUM_ALT_CHARS = '〇一二三四五六七八九０１２３４５６７８９零壱壹弌弐貳貮参參弎肆伍陸漆質柒捌玖拾什陌佰阡仟萬秭'.freeze
  NUM_NORMALIZED_CHARS = '01234567890123456789011122233345677789十十百百千千万𥝱'.freeze
  REGEXP_PART = %r{
    [
      #{(NUM_ALT_CHARS + NUM_NORMALIZED_CHARS).chars.uniq.join}
      #{(UNIT_EXP3 + UNIT_EXP4).find_all { |u| u.length == 1 }}
      卄廿卅丗卌皕
    ] |
    #{UNIT_EXP4.find_all { |u| u.length > 1 }.join('|')}
  }x.freeze
  REGEXP = /(?:#{REGEXP_PART})+/.freeze
  @@formatters = {}

  module_function

  def to_i(str)
    str = str.to_s.tr(NUM_ALT_CHARS, NUM_NORMALIZED_CHARS)
    str.gsub!(/[,，、:space:]/, '')
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
        ret4 += ret3 * 10**((UNIT_EXP4.index(c) + 1) * 4)
        ret3 = 0
      when *UNIT_EXP3
        curnum ||= 1
        ret3 += curnum * 10**(UNIT_EXP3.index(c) + 1)
        curnum = nil
      end
    end
    if curnum
      ret3 += curnum
      curnum = nil
    end
    ret4 + ret3
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
    num = num.respond_to?(:_to_i_ya_kansuji_orig) ? num._to_i_ya_kansuji_orig : num.to_i
    if formatter.respond_to? :call
      formatter.call num, options
    elsif @@formatters[formatter]
      @@formatters[formatter].call num, options
    else
      raise ArgumentError, "Unable to find formatter #{formatter}"
    end
  end
end

require 'ya_kansuji/formatter/simple'
require 'ya_kansuji/formatter/gov'
require 'ya_kansuji/formatter/lawyer'
require 'ya_kansuji/formatter/judic_v'
require 'ya_kansuji/formatter/judic_h'
