# TODO: STUB!!

# UltKansuji - ruby 漢数字ライブラリ

Yet another (Ultra/Ultimate) Japanese Kansuji library for ruby.

UltKansuji ruby 用の日本語の漢数字ライブラリです。 和暦ライブラリの [wareki](https://github.com/sugi/wareki) から派生していますが、アラビア数字混じりの漢数字表記など、かなり多彩な表現を数値と相互変換することができます。

日本語以外の漢数字に関しては一切サポートしていません。

## 機能 / Features

* 読み取り: 以下の混在したテキストを数値に変換出来ます
  * 漢数字
  * 全角数字
  * 単位なし (
  * ゼロ (
  * 位取り (
  * 大字 (
  * カンマ表現
* 数値から漢数字, 漢字混じり数値文字列フォーマット
  * 複数のビルトインフォーマッタ
  * フォーマッタプラグイン機構
* 標準の String, Number クラスの拡張 (必要があれば)


## インストール / Installation

Add this line to your application's Gemfile:

```ruby
gem 'ult_kansuji'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ult_kansuji


## 使い方 / Usage

### 読み取り (漢数字 →  数値) / Parse kansuji

TODO: Write usage instructions here

### フォーマット (数値 → 漢数字) / 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sugi/ult_kansuji.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

Tatsuki Sugiura <sugi@nemui.org>
