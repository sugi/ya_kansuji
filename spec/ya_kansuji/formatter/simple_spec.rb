require 'spec_helper'
RSpec.describe YaKansuji::Formatter::Simple do
  def k(num, opt = {})
    subject.call num, opt
  end

  it 'can convert number to kansuji' do
    expect(k(0)).to eq '零'
    expect(k(1)).to eq '一'
    expect(k(1234)).to eq '千二百三十四'
    expect(k(10_003)).to eq '一万三'
    expect(k(10_010_003)).to eq '千一万三'
    expect(k(100_000_003)).to eq '一億三'
    expect(k(200_000_000_056)).to eq '二千億五十六'
    expect(k(9_030_000_001_008)).to eq '九兆三百億千八'

    expect(k(9_999_999)).to eq '九百九十九万九千九百九十九'
    expect(k(900_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000)).to eq '九十不可思議'
    expect(k(100_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000)).to eq '一無量大数'
    expect(k(111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111)).to eq '千百十一無量大数千百十一不可思議千百十一那由他千百十一阿僧祇千百十一恒河沙千百十一極千百十一載千百十一正千百十一澗千百十一溝千百十一穣千百十一𥝱千百十一垓千百十一京千百十一兆千百十一億千百十一万千百十一'
    expect(k(999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999)).to eq '九千九百九十九無量大数九千九百九十九不可思議九千九百九十九那由他九千九百九十九阿僧祇九千九百九十九恒河沙九千九百九十九極九千九百九十九載九千九百九十九正九千九百九十九澗九千九百九十九溝九千九百九十九穣九千九百九十九𥝱九千九百九十九垓九千九百九十九京九千九百九十九兆九千九百九十九億九千九百九十九万九千九百九十九'
  end
end
