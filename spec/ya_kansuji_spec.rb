# frozen_string_literal: true

RSpec.describe YaKansuji do
  let(:u) { described_class }

  it 'has a version number' do
    expect(YaKansuji::VERSION).not_to be_nil
  end

  it 'can convert kansuji to number' do
    expect(u.to_i('千二百三十四')).to eq 1234
    expect(u.to_i('百卄')).to eq 120
    expect(u.to_i('一二三四')).to eq 1234
    expect(u.to_i('千皕卅肆')).to eq 1234
    expect(u.to_i('一〇〇〇五')).to eq 10_005
    expect(u.to_i('〇')).to eq 0
    expect(u.to_i('零')).to eq 0
    expect(u.to_i('元')).to eq 0
    expect(u.to_i('五万廿')).to eq 50_020
    expect(u.to_i('百七十八万二')).to eq 1_780_002
    expect(u.to_i('九億６千万卌一')).to eq 960_000_041
    expect(u.to_i('肆陸')).to eq 46
    expect(u.to_i('弐仟柒佰玖什')).to eq 2790
    expect(u.to_i('捌萬貳拾')).to eq 80_020
    expect(u.to_i('伍〇')).to eq 50
    expect(u.to_i('000023')).to eq 23
    expect(u.to_i('一千〇二十四')).to eq 1024
    expect(u.to_i('二百二十二万零三百零二')).to eq 2_220_302
    expect(u.to_i('六百〇八')).to eq 608
    expect(u.to_i('六百十')).to eq 610
    expect(u.to_i('千〇〇三億')).to eq 100_300_000_000
    expect(u.to_i('千〇十')).to eq 1010
    expect(u.to_i('何か千〇十とか1')).to eq 1010
  end

  it 'can convert number with comma' do
    expect(u.to_i('1,000億 5,432万')).to eq 100_054_320_000
    expect(u.to_i('12,345')).to eq 12_345
    expect(u.to_i('二万、五十')).to eq 20_050
  end

  it 'does not treat double quote as a numeric character' do
    expect(u.to_i(%(1"000))).to eq 1
    expect(u.to_i(%(一"二))).to eq 1
  end

  it 'still matches the tail of the character class after the fix' do
    expect(u.to_i('丗')).to eq 30
  end

  it 'can parse a leading マイナス as a negative sign' do
    expect(u.to_i('マイナス千二百三十四')).to eq(-1234)
    expect(u.to_i('マイナス12,345')).to eq(-12_345)
    expect(u.to_i('マイナス 五十')).to eq(-50)
    expect(u.to_i('マイナス〇')).to eq 0
    expect(u.to_i('マイナス思考で3日')).to eq 3
    expect(u.to_i('マイナス')).to eq 0
    expect(u.to_i('五マイナス三')).to eq 5
  end

  it 'can format a negative number with a leading マイナス' do
    expect(u.to_kan(-1234)).to eq 'マイナス千二百三十四'
    expect(u.to_kan(-0.5)).to eq '零'
    expect(u.to_kan(-10_003, :gov)).to eq 'マイナス1万, 3'
    expect(u.to_kan('-123')).to eq 'マイナス百二十三'
  end

  it 'round-trips a negative number through to_kan and to_i' do
    expect(u.to_i(u.to_kan(-98_765))).to eq(-98_765)
  end

  it 'does not treat ASCII/Unicode minus signs as negative markers' do
    expect(u.to_i('2019-04')).to eq 2019
    expect(u.to_i('-123')).to eq 123
    expect(u.to_i('−123')).to eq 123
  end

  it 'keeps minus round-trip across builtin formatters' do
    %i(simple gov lawyer judic_v judic_h).each do |fmt|
      expect(u.to_i(u.to_kan(-98_765, fmt))).to eq(-98_765)
    end
  end

  describe '.to_kan supported range' do
    let(:first_unsupported_value) { 10**72 }
    let(:builtin_formatters) { %i(simple gov lawyer judic_v judic_h) }

    it 'formats the largest supported value without losing digits' do
      value = first_unsupported_value - 1

      expect(u.to_i(u.to_kan(value))).to eq value
      expect(value).to eq described_class::MAX_VALUE
    end

    it 'validates the value after applying the existing integer coercion' do
      expect { u.to_kan(first_unsupported_value.to_s) }.to raise_error(RangeError)
    end

    it 'rejects positive and negative out-of-range values for every builtin formatter' do
      builtin_formatters.each do |formatter|
        expect { u.to_kan(first_unsupported_value, formatter) }.to raise_error(RangeError)
        expect { u.to_kan(-first_unsupported_value, formatter) }.to raise_error(RangeError)
      end
    end
  end
end
