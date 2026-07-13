require 'spec_helper'
RSpec.describe YaKansuji::Formatter do
  def format_with(formatter, number)
    YaKansuji.to_kan(number, formatter)
  end

  def one_for(formatter)
    {
      simple: '一',
      gov: '1',
      lawyer: '1',
      judic_v: '一',
      judic_h: '１',
    }[formatter]
  end

  def formatted_1234_for(formatter)
    {
      simple: '千二百三十四',
      gov: '1234',
      lawyer: '1,234',
      judic_v: '一二三四',
      judic_h: '１２３４',
    }[formatter]
  end

  it 'can register formatter with proc' do
    proc1 = proc { 'p1' }
    expect(YaKansuji.register_formatter(:proc1, proc1)).to be_truthy
    expect(YaKansuji.formatter(:proc1)).to eq proc1
  end

  it 'can register formatter with lambda' do
    lambda1 = -> { 'l1' }
    expect(YaKansuji.register_formatter(:lambda1, lambda1)).to be_truthy
    expect(YaKansuji.formatter(:lambda1)).to eq lambda1
  end

  it 'can register formatter with callable object' do
    o1 = Object.new
    def o1.call
      'o1'
    end
    expect(YaKansuji.register_formatter(:o1, o1)).to be_truthy
    expect(YaKansuji.formatter(:o1)).to eq o1
  end

  it 'raises exception with non-callable' do
    expect do
      YaKansuji.register_formatter :t, true
    end.to raise_error(ArgumentError)

    expect do
      YaKansuji.register_formatter :one, 1
    end.to raise_error(ArgumentError)

    expect do
      YaKansuji.register_formatter :str, 'hoge'
    end.to raise_error(ArgumentError)
  end

  it 'can run custom formatter' do
    YaKansuji.register_formatter :hoge,
                                 lambda { |num, _opts = {}|
                                   case num
                                   when 0 then ''
                                   when 1 then 'いち'
                                   when 2 then 'に'
                                   else
                                     'たくさん'
                                   end
                                 }
    expect(YaKansuji.to_kan(1, :hoge)).to eq 'いち'
    expect(YaKansuji.to_kan(4, :hoge)).to eq 'たくさん'

    YaKansuji.register_formatter :rule4, ->(num, _opts = {}) { (num % 4).to_s }
    10.times do
      num = rand(1_000_000)
      expect(YaKansuji.to_kan(num, :rule4)).to eq (num % 4).to_s
    end
  end

  it 'passes only the absolute value to the formatter; to_kan prepends the sign' do
    YaKansuji.register_formatter :abs_check, ->(num, _opts = {}) { num.to_s }
    expect(YaKansuji.to_kan(-42, :abs_check)).to eq 'マイナス42'
  end

  describe 'built-in formatter chunk boundaries' do
    describe 'at the first four-digit chunk boundary' do
      expectations = {
        simple: {
          9_999 => '九千九百九十九',
          10_000 => '一万',
          10_001 => '一万一',
        },
        gov: {
          9_999 => '9999',
          10_000 => '1万',
          10_001 => '1万, 1',
        },
        lawyer: {
          9_999 => '9,999',
          10_000 => '1万',
          10_001 => '1万1',
        },
        judic_v: {
          9_999 => '九九九九',
          10_000 => '一万',
          10_001 => '一万〇〇〇一',
        },
        judic_h: {
          9_999 => '９９９９',
          10_000 => '１万',
          10_001 => '１万０００１',
        },
      }

      expectations.each do |formatter, cases|
        cases.each do |number, formatted|
          it "formats #{number} with #{formatter}" do
            expect(format_with(formatter, number)).to eq formatted
          end
        end
      end
    end

    describe 'with zero chunks between non-zero chunks' do
      expectations = {
        simple: %w(一億一 一兆一万 一兆一億一万),
        gov: [
          '1億, 1',
          '1兆, 1万',
          '1兆, 1億, 1万'
        ],
        lawyer: %w(1億1 1兆1万 1兆1億1万),
        judic_v: %w(一億〇〇〇一 一兆〇〇〇一万 一兆〇〇〇一億〇〇〇一万),
        judic_h: %w(１億０００１ １兆０００１万 １兆０００１億０００１万),
      }
      numbers = [100_000_001, 1_000_000_010_000, 1_000_100_010_000]

      expectations.each do |formatter, formatted_values|
        numbers.each_with_index do |number, index|
          it "skips zero chunks when formatting #{number} with #{formatter}" do
            expect(format_with(formatter, number)).to eq formatted_values[index]
          end
        end
      end
    end

    describe 'at every named four-digit unit' do
      formatters = %i(simple gov lawyer judic_v judic_h)

      YaKansuji::UNIT_EXP4.each_with_index do |unit, index|
        formatters.each do |formatter|
          it "maps 10**#{(index + 1) * 4} to #{unit} with #{formatter}" do
            number = 10**((index + 1) * 4)
            expect(format_with(formatter, number)).to eq "#{one_for(formatter)}#{unit}"
          end
        end
      end
    end

    describe 'above the largest supported chunk' do
      %i(simple gov lawyer judic_v judic_h).each do |formatter|
        it "keeps the current truncation behavior for 10**72 with #{formatter}" do
          expect(format_with(formatter, 10**72)).to eq ''
        end

        it "keeps the current truncation behavior for 10**72 + 1 with #{formatter}" do
          expect(format_with(formatter, (10**72) + 1)).to eq one_for(formatter)
        end

        it "truncates multiple unsupported chunks with #{formatter}" do
          expect(format_with(formatter, (10**76) + 1_234)).to eq formatted_1234_for(formatter)
        end
      end

      it 'keeps the empty Simple result UTF-8 encoded' do
        result = format_with(:simple, 10**72)

        expect(result.encoding).to eq Encoding::UTF_8
      end
    end
  end

  describe YaKansuji::Formatter::Simple do
    describe 'around decimal unit boundaries within a chunk' do
      expectations = {
        1 => '一',
        9 => '九',
        10 => '十',
        11 => '十一',
        99 => '九十九',
        100 => '百',
        101 => '百一',
        999 => '九百九十九',
        1_000 => '千',
        1_001 => '千一',
      }

      expectations.each do |number, formatted|
        it "formats #{number}" do
          expect(described_class.call(number)).to eq formatted
        end
      end
    end
  end
end
