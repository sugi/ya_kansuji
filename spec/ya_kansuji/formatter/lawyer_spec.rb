require 'spec_helper'
RSpec.describe YaKansuji::Formatter::Lawyer do
  def k(num, opt = {})
    subject.call num, opt
  end

  it 'can convert number to kansuji' do
    expect(k(0)).to eq '0'
    expect(k(1)).to eq '1'
    expect(k(1234)).to eq '1,234'
    expect(k(10_003)).to eq '1万3'
    expect(k(10_010_003)).to eq '1,001万3'
    expect(k(100_000_003)).to eq '1億3'
    expect(k(200_000_000_056)).to eq '2,000億56'
    expect(k(9_030_000_001_008)).to eq '9兆300億1,008'

    expect(k(9_999_999)).to eq '999万9,999'
    expect(k(900_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000)).to eq '90不可思議'
    expect(k(100_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000_000)).to eq '1無量大数'
    expect(k(111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111_111)).to eq '1,111無量大数1,111不可思議1,111那由他1,111阿僧祇1,111恒河沙1,111極1,111載1,111正1,111澗1,111溝1,111穣1,111𥝱1,111垓1,111京1,111兆1,111億1,111万1,111'
    expect(k(999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999_999)).to eq '9,999無量大数9,999不可思議9,999那由他9,999阿僧祇9,999恒河沙9,999極9,999載9,999正9,999澗9,999溝9,999穣9,999𥝱9,999垓9,999京9,999兆9,999億9,999万9,999'
  end
end
