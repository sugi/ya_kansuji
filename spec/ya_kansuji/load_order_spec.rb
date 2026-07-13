# frozen_string_literal: true

require 'spec_helper'
require 'open3'
require 'rbconfig'

# Load order is integration behavior rather than behavior owned by one class.
# rubocop:disable RSpec/DescribeClass
RSpec.describe 'YaKansuji load order' do
  let(:lib_path) { File.expand_path('../../lib', __dir__) }

  load_orders = {
    'main entrypoint' => "require 'ya_kansuji'",
    'core_refine entrypoint' => "require 'ya_kansuji/core_refine'",
    'main then core_refine' => "require 'ya_kansuji'; require 'ya_kansuji/core_refine'",
    'core_refine then main' => "require 'ya_kansuji/core_refine'; require 'ya_kansuji'",
  }

  load_orders.each do |description, requires|
    it "loads #{description} without a circular require" do
      script = <<-RUBY
        #{requires}
        abort 'CoreRefine is unavailable' unless defined?(YaKansuji::CoreRefine)
        abort 'YaKansuji.to_i is unavailable' unless YaKansuji.to_i('十二') == 12
        abort 'YaKansuji.to_kan is unavailable' unless YaKansuji.to_kan(12) == '十二'

        using YaKansuji::CoreRefine
        abort 'String refinement failed' unless '十二'.to_i(:kansuji) == 12
        abort 'Integer refinement failed' unless 12.to_kan == '十二'
      RUBY

      stdout, stderr, status = Open3.capture3(
        RbConfig.ruby, '-w', '-I', lib_path, '-e', script
      )

      expect(status).to be_success, "stdout:\n#{stdout}\nstderr:\n#{stderr}"
      expect(stderr).not_to include('circular require')
    end
  end
end
# rubocop:enable RSpec/DescribeClass
