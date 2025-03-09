require 'spec_helper'
RSpec.describe YaKansuji::Formatter do
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
end
