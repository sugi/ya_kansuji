RSpec.describe YaKansuji do
  it "can register formatter with proc" do
    proc1 = proc {"p1"}
    expect(YaKansuji.register_formatter :proc1, proc1).to be_truthy
    expect(YaKansuji.formatter(:proc1)).to eq proc1
  end

  it "can register formatter with lambda" do
    lambda1 = lambda {"l1"}
    expect(YaKansuji.register_formatter :lambda1, lambda1).to be_truthy
    expect(YaKansuji.formatter(:lambda1)).to eq lambda1
  end

  it "can register formatter with callable object" do
    o1 = Object.new
    def o1.call;  "o1"; end
    expect(YaKansuji.register_formatter :o1, o1).to be_truthy
    expect(YaKansuji.formatter(:o1)).to eq o1
  end

  it "raises exception with non-callable" do
    expect {
      YaKansuji.register_formatter :t, true
    }.to raise_error(ArgumentError)

    expect {
      YaKansuji.register_formatter :one, 1
    }.to raise_error(ArgumentError)

    expect {
      YaKansuji.register_formatter :str, "hoge"
    }.to raise_error(ArgumentError)
  end

  it "can run formatter" do
    YaKansuji.register_formatter :hoge,
      -> (num, opts = {}) {
      if num == 0 ;   ""
      elsif num == 1; "いち"
      elsif num == 2; "に"
      else;           "たくさん"
      end
    }
    expect(YaKansuji.to_kan(1, :hoge)).to eq "いち"
    expect(YaKansuji.to_kan(4, :hoge)).to eq "たくさん"
  end

end