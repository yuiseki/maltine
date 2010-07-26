class IndexController < ApplicationController
  layout "index"

  # inputからtokenがPOSTでsubmitされてくる
  # 有効なtokenだったら認証を付与しダウンロード画面を表示する
  def downloader
    if params["token"]
      @token = Token.find_by_token(params["token"]["token"])
      # sessionにtokenを埋め込む
      session[:token] = @token.token if @token
    end
    # tokenなし
    render :text=> "401 Unauthorized", :status=>'401 Unauthorized' and return unless @token
  end

  # 認証済み状態で曲を取得するためのGETメソッド
  def fetch_zip
    filename = params["filename"]
    # sessionからtokenを復元
    @token = Token.find_by_token(session[:token])
    if @token
      send_file("unpublic/#{filename}.zip")
    else
      render :text=> "401 Unauthorized", :status=>'401 Unauthorized' and return
    end
  end


  # tokenとtwitter userを紐付けするためのビュー
  def twitter_auth
    @token = Token.find_by_token(session[:token])
    if @token
      if current_user
        # twitterにログインしている
        unless @token.user
          # まだtokenとuserは紐付けられていないか？
          @token.user_id = current_user.id
          @token.save
        else
          # 使用済みtokenであることを警告する
        end
      else
        # twitterにログインしていない→ログイン画面にとばす
      end
    end
  end

  # ユーザーアクション一覧
  def buyers
    @recent_logins = User.find(:all, :order => "updated_at DESC")
    @used_tokens = Token.find(:all, :conditions => ["user_id is NOT NULL", ], :order => "updated_at DESC")
  end


  # ユーザーホーム
  # token入力済み or twitterログイン済み
  def home
    if current_user
      hoge
    else
      render :text=> "401 Unauthorized", :status=>'401 Unauthorized' and return
    end
  end

  # 各ユーザーの公開ページ
  def user
    @user = User.find_by_login(params["login"])
    render :file=> "public/404.html", :status=>'404 Not Found' and return unless @user
  end


  # 各曲のページ
  def track
    @users = User.find(:all, :order => "updated_at DESC")
  end


=begin
  # トークン一覧をカンマ区切りで出力
  def tokens
    @available_tokens = Token.find(:all, :conditions => ["user_id is NULL", ], :order => "updated_at DESC")
    render :text => @available_tokens.collect{|t| t.token }.join("\n")
  end
=end

end
