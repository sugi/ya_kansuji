# frozen_string_literal: true

require 'spec_helper'

module CoreRefineExamples
  using YaKansuji::CoreRefine

  module_function

  def parse(value, base = nil)
    value.to_i(base)
  end

  def format(value, formatter = :simple, options = {})
    value.to_kan(formatter, options)
  end
end

RSpec.describe YaKansuji::CoreRefine do
  it 'accepts both kansuji aliases in String#to_i' do
    expect(CoreRefineExamples.parse('二万', :kan)).to eq 20_000
    expect(CoreRefineExamples.parse('二万', :kansuji)).to eq 20_000
  end

  it 'delegates a numeric base to the original String#to_i' do
    expect(CoreRefineExamples.parse('12', 16)).to eq 18
  end

  it 'passes the formatter and options through Integer#to_kan' do
    formatter = ->(num, options) { "#{num}:#{options.fetch(:suffix)}" }

    expect(CoreRefineExamples.format(20_000, :gov)).to eq '2万'
    expect(CoreRefineExamples.format(12, formatter, suffix: '個')).to eq '12:個'
  end

  it 'adds to_kan to Float and Rational' do
    expect(CoreRefineExamples.format(0.5)).to eq '五分'
    expect(CoreRefineExamples.format(1.05, :judic_h)).to eq '１．０５'
    expect(CoreRefineExamples.format(Rational(1, 4), :gov)).to eq '0.25'
  end
end
