require 'json'

input = JSON.parse(File.read("input.json"))

# user_code.rb に書き出し
File.write("user_code.rb", input["user_code"])

# test_code.rb に書き出し（require もここで付与）
test_code_full = <<~RUBY
  require_relative './user_code'
  #{input["test_code"]}
RUBY

File.write("test_code.rb", test_code_full)

# 実行
puts "=== ユーザーコード ==="
puts input["user_code"]
puts "=== テストコード ==="
puts input["test_code"]

puts "=== 実行結果 ==="
begin
  result = `ruby test_code.rb`
  puts result
  puts "✅ テスト成功"
rescue => e
  puts "❌ テスト失敗"
  puts e.message
end