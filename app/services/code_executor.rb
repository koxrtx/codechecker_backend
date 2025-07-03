# ユーザーコードをDockerで実行＆テスト判定
class CodeExecutor
  def self.run(user_code, test_code, method_name)
    # input.json を書き出す
    input = {
      user_code: user_code,
      test_code: test_code,
      method_name: method_name
    }
    input_path = Rails.root.join("sandbox/input.json")
    File.write(input_path, input.to_json)

    # Docker build & run 実行（エラーも含めて文字列で受け取る）
    result = `docker build -f sandbox/sandbox.Dockerfile -t ruby-sandbox . && \
              docker run --rm -v #{Rails.root.join("sandbox")}:/runner ruby-sandbox 2>&1`

    result
  end
end