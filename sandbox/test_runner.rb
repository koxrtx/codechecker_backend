require 'json'

input = JSON.parse(File.read("input.json"))
user_code = input["user_code"]
test_code = input["test_code"]
expected_method = input["method_name"]

# 書き出し
File.write("user_code.rb", user_code)

# ユーザーコードからメソッド名抽出して調整
actual_method = user_code.match(/def\s+(\w+)/)[1]
if actual_method != expected_method
  user_code.gsub!(/def\s+#{actual_method}/, "def #{expected_method}")
  File.write("user_code.rb", user_code)
end

# ユーザーコードを読み込む
load './user_code.rb'

# テストコードを評価
eval(test_code)

puts "=== テスト結果 ==="
success = Minitest.run
puts success ? "✅ テスト成功" : "❌ テスト失敗"