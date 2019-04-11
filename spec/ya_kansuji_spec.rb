RSpec.describe YaKansuji do
  u = YaKansuji

  it "has a version number" do
    expect(YaKansuji::VERSION).not_to be nil
  end

  it "can convert kansuji to number" do
    expect(u.to_i("千二百三十四")).to eq 1234
    expect(u.to_i("百卄")).to eq 120
    expect(u.to_i("一二三四")).to eq 1234
    expect(u.to_i("千皕卅肆")).to eq 1234
    expect(u.to_i("一〇〇〇五")).to eq 10005
    expect(u.to_i("〇")).to eq 0
    expect(u.to_i("零")).to eq 0
    expect(u.to_i("元")).to eq 0
    expect(u.to_i("五万廿")).to eq 50020
    expect(u.to_i("百七十八万二")).to eq 1780002
    expect(u.to_i("九億６千万卌一")).to eq 960000041
    expect(u.to_i("肆陸")).to eq 46
    expect(u.to_i("弐仟柒佰玖什")).to eq 2790
    expect(u.to_i("捌萬貳拾")).to eq 80020
    expect(u.to_i("伍〇")).to eq 50
    expect(u.to_i("000023")).to eq 23
    expect(u.to_i("一千〇二十四")).to eq 1024
    expect(u.to_i("二百二十二万零三百零二")).to eq 2220302
    expect(u.to_i("六百〇八")).to eq 608
    expect(u.to_i("六百十")).to eq 610
    expect(u.to_i("千〇〇三億")).to eq 100300000000
    expect(u.to_i("千〇十")).to eq 1010
    expect(u.to_i("何か千〇十とか1")).to eq 1010

  end

  it "can convert number to kansuji" do
    expect(u.to_kan(1234)).to eq "千二百三十四"
    expect(u.to_kan(10003)).to eq "一万三"
    expect(u.to_kan(10_010_003)).to eq "千一万三"
    expect(u.to_kan(100_000_003)).to eq "一億三"
    expect(u.to_kan(200_000_000_056)).to eq "二千億五十六"
    expect(u.to_kan(9_030_000_001_008)).to eq "九兆三百億千八"
  end

end
