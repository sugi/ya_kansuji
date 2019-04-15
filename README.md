# TODO: THIS GEM IS STILL BETA VERSION.

# YaKansuji - もう一つの (やりすぎ) ruby 漢数字ライブラリ

[<img src="https://badge.fury.io/rb/ya_kansuji.svg" alt="Gem Version" />](https://badge.fury.io/rb/ya_kansuji)
[<img src="https://travis-ci.org/sugi/ya_kansuji.svg?branch=master" alt="Build Status" />](https://travis-ci.org/sugi/ya_kansuji)
[<img src="https://coveralls.io/repos/sugi/ya_kansuji/badge.svg?branch=master&service=github" alt="Coverage Status" />](https://coveralls.io/github/sugi/ya_kansuji?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/007f79c6f7f6e82daa20/maintainability)](https://codeclimate.com/github/sugi/ya_kansuji/maintainability)

Yet another (ultimate) Japanese Kansuji library for ruby.

YaKansuji は ruby 用の日本語の漢数字ライブラリです。 和暦ライブラリの [wareki](https://github.com/sugi/wareki) から派生していますが、アラビア数字混じりの漢数字表記など、もう少し多彩な表現を数値と相互変換することができます。

現状のサポートは日本語で万進な10進数だけです。歴史的に使われたことのあった万万進や他の漢字圏の漢数字はサポートしていません。

## 機能 / Features

* 読み取り: 以下の混在したテキストを数値に変換出来ます
  * 漢数字 (二万三千五百六十七)
  * 全角数字 (１２３４)
  * 単位なし / ゼロ (一六九〇)
  * 位取り (2億0010万 / 千〇〇二)
  * 大字 (千皕卅肆)
  * カンマ表現 (12,345 / 5億3,456万 / 二万、五十 )
* 数値から漢数字, 漢字混じり数値文字列フォーマット
  * 複数のビルトインフォーマッタ
  * フォーマッタプラグイン機構
* (オプション) 標準の String, Interger クラスの拡張

## インストール / Installation

Gemfile に以下のようにして、bundle を実行するか、

```ruby
gem 'ya_kansuji'
```

もしくは gem コマンドで直接インストールしてください。

    $ gem install ya_kansuji

## 使い方

### 読み取り (漢数字 →  数値)

`YaKansuji#to_i` に文字を渡すと数値に変換できます。読み取りに関してはオプションはありません。

```ruby
YaKansuji.to_i("一〇二四") # => 1024
```

### フォーマット (数値 → 漢数字)

`YaKansuji#to_kan` に数値を渡すことで、漢数字や漢字混じりの文字列に変換します。

```ruby
YaKansuji.to_kan(12345)  # => 一万二千三百四十五
```

このさい、2つめの引数にシンボルを渡すことにより、フォーマッタを切り替えることができます(TODO: 予定)。

```ruby
YaKansuji.to_kan(12340005, :simple)  # => "千二百三十四万五"
YaKansuji.to_kan(12340005, :gov)     # => "1234万, 5"
YaKansuji.to_kan(12340005, :lawyer)  # => "1,234万5"
YaKansuji.to_kan(12340005, :judic_v) # => "一二三四万〇〇〇五"
YaKansuji.to_kan(12340005, :judic_h) # => "１２３４万０００５"
```

現在あるフォーマッタは以下のとおりです。

 * `simple` - 標準 (例: 千二百三十四万五)
 * TODO ~~`gov` - 「公用文作成の要領」方式 (100億, 30万円 / 5,000)~~
 * TODO ~~`lawyer` - 行政司法協会方式 (1,200億 / 2億58万6,300)~~
 * TODO ~~`judic_v` - 裁判判例縦書き方式 (一二万〇〇五六)~~
 * TODO ~~`judic_h` - 最高裁判例横書き方式 (５万０５３９)~~

#### 独自フォーマッタ

`YaKansuji#register_formatter` を使うと独自のフォーマッタを登録できます。
`call` を持つオブジェクトなら何でも渡せます。第1引数に数字、第2引数にオプションが渡ります。

```ruby
YaKansuji.register_formatter :hoge, -> (num, opts = {}) {
  if num == 0;    ""
  elsif num == 1; "いち"
  elsif num == 2; "に"
  else;           "たくさん"
  end
}
YaKansuji.to_kan(2,   :hoge)   # => "に"
YaKansuji.to_kan(123, :hoge)   # => "たくさん"
```

### 標準クラス拡張

標準では YaKansuji の特異メソッドを直接呼ぶことで使用できますが、短く書く場合、必要応じてビルトインクラス (String, Integer) の拡張を使うことができます。

クラス拡張では `String#to_i` を置き換え、 `Integer#to_kan` を追加します。
拡張の方法は、Refinements と直接拡張の好きな方を選択できます。

#### [Refinements](https://docs.ruby-lang.org/en/2.6.0/syntax/refinements_rdoc.html) による拡張

`YaKansuji::CoreRefine` を using すると、 `String#to_i` を置き換え、 `Integer#to_kan` を追加します。

```ruby
puts "二万".to_i     # => 0

using YaKansuji::CoreRefine

puts "二万".to_i     # => 20000
puts 20000.to_kan   #= > "二万"
```

ちなみに、 `to_i` に base が渡された場合は、漢数字が解釈されずにビルトインクラスのものが呼ばれます。

```ruby
using YaKansuji::CoreRefine

puts "12万".to_i      # => 120000
puts "12万".to_i(16)  # => 18
```

#### メソッド上書き

Refinements を使わずに、全域でビルトインクラスを上書きしたい場合は `ya_kansuji/core_ext` を読み込んでください。*これは破壊的にコアライブラリのメソッドを置き換えるため、影響範囲に注意して下さい。*
上書きや提供されるメソッドは Refinements と同じです。

```ruby
require 'ya_kansuji/core_ext'
```

bundler を使っている場合は、 `Gemfile` 中で以下のようにできます。

```ruby
gem 'ya_kansuji', require: 'ya_kansuji/core_ext'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sugi/ya\_kansuji.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

Tatsuki Sugiura <sugi@nemui.org>
