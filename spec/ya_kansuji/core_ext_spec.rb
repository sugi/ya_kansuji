# frozen_string_literal: true

require 'spec_helper'
require 'ya_kansuji/core_ext'

# There is no single class under test because these are destructive core extensions.
# rubocop:disable RSpec/DescribeClass
RSpec.describe 'YaKansuji core extensions' do
  it 'accepts both kansuji aliases in String#to_i' do
    expect('二万'.to_i(:kan)).to eq 20_000
    expect('二万'.to_i(:kansuji)).to eq 20_000
  end

  it 'delegates a numeric base to the original String#to_i' do
    expect('12'.to_i(16)).to eq 18
  end

  it 'passes the formatter and options through Integer#to_kan' do
    formatter = ->(num, options) { "#{num}:#{options.fetch(:suffix)}" }

    expect(20_000.to_kan(:gov)).to eq '2万'
    expect(12.to_kan(formatter, suffix: '個')).to eq '12:個'
  end

  it 'adds to_kan to Float and Rational' do
    expect(0.5.to_kan).to eq '五分'
    expect(1.05.to_kan(:judic_h)).to eq '１．０５'
    expect(Rational(1, 4).to_kan(:gov)).to eq '0.25'
  end
end
# rubocop:enable RSpec/DescribeClass
