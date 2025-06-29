class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # フラッシュメッセージ追加
  add_flash_types :success, :danger

  private

  # ログインしてなかったらマイページに行こうとしたらログイン画面にへ移行する
  def not_authenticated
    redirect_to login_path
  end
end
