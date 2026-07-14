# frozen_string_literal: true

require 'spec_helper'
require 'bigdecimal'

# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe YaKansuji do
  let(:u) { described_class }

  describe 'UNIT_FRAC' do
    it 'has 21 units from 分 to 清浄' do
      expect(u::UNIT_FRAC.size).to eq 21
      expect(u::UNIT_FRAC.first).to eq '分'
      expect(u::UNIT_FRAC.last).to eq '清浄'
      expect(u::FRAC_BASE).to eq 10**21
    end
  end

  describe '.normalize_value' do
    it 'passes integers through' do
      expect(u.normalize_value(123)).to eq 123
      expect(u.normalize_value(123)).to be_a Integer
      expect(u.normalize_value(-5)).to eq(-5)
    end

    it 'converts non-numeric values with to_i as before' do
      expect(u.normalize_value('-123')).to eq(-123)
      expect(u.normalize_value(nil)).to eq 0
    end

    it 'converts floats via their shortest decimal representation' do
      expect(u.normalize_value(0.1)).to eq Rational(1, 10)
      expect(u.normalize_value(1.5)).to eq Rational(3, 2)
      expect(u.normalize_value(-1.5)).to eq Rational(-3, 2)
      expect(u.normalize_value(0.00001)).to eq Rational(1, 100_000)
      expect(u.normalize_value(1.0e+20)).to eq 10**20
    end

    it 'returns an Integer for integral values' do
      expect(u.normalize_value(1.0)).to eq 1
      expect(u.normalize_value(1.0)).to be_a Integer
      expect(u.normalize_value(Rational(4, 2))).to eq 2
      expect(u.normalize_value(Rational(4, 2))).to be_a Integer
    end

    it 'accepts Rational and BigDecimal exactly' do
      expect(u.normalize_value(Rational(1, 4))).to eq Rational(1, 4)
      expect(u.normalize_value(BigDecimal('3.14159'))).to eq Rational('3.14159')
    end

    it 'rounds the fraction at 21 digits, half away from zero' do
      expect(u.normalize_value(Rational(1, 3)))
        .to eq Rational('0.333333333333333333333')
      expect(u.normalize_value(Rational(2, 3)))
        .to eq Rational('0.666666666666666666667')
      expect(u.normalize_value(Rational(1, 10**22))).to eq 0
      expect(u.normalize_value(Rational(5, 10**22))).to eq Rational(1, 10**21)
    end

    it 'carries rounding over into the integer part' do
      expect(u.normalize_value(Rational((10**22) - 1, 10**22))).to eq 1
      expect(u.normalize_value(Rational(-((10**22) - 1), 10**22))).to eq(-1)
    end

    it 'raises FloatDomainError for NaN and Infinity' do
      expect { u.normalize_value(Float::NAN) }.to raise_error FloatDomainError
      expect { u.normalize_value(Float::INFINITY) }.to raise_error FloatDomainError
      expect { u.normalize_value(-Float::INFINITY) }.to raise_error FloatDomainError
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
