class IndexController < ApplicationController
  layout "index"
  # トップページ
  def top
    @recent_logins = User.find(:all, :order => "updated_at DESC")
    @available_tokens = Token.find(:all, :conditions => ["user_id is NULL", ], :order => "updated_at DESC")
    @used_tokens = Token.find(:all, :conditions => ["user_id is NOT NULL", ], :order => "updated_at DESC")
  end




  # 曲をダウンロードしつつアカウントとトークンを紐付けるPOSTメソッド
  def downloader
    @token = Token.find_by_token(params["token"]["token"])
    if @token
      if current_user
        unless @token.user
          @token.user_id = current_user.id
          @token.save
        end
      end
      # TODO attachiment
      send_file('unpublic/miu.jpg')
    else
      render :file=> "public/422.html", :status=>'422 The change you wanted was rejected'
      return
    end
  end
  # ログイン状態で曲を取得するためのGETメソッド
  def fetch
    filename = params["mp3"]
    if current_user.token
      token = current_user.token.token
      @token = Token.find_by_token(token)
      if @token
        send_file("unpublic/#{filename}.mp3")
      end
    else
      render :file=> "public/422.html", :status=>'422 The change you wanted was rejected'
      return
    end
  end


  # ユーザーホーム


  # 各ユーザーのページ
  def user
    @user = User.find_by_login(params["login"])
    render :file=> "public/404.html", :status=>'404 Not Found' and return unless @user
  end
  # 各曲のページ
  def track
    @users = User.find(:all, :order => "updated_at DESC")
  end




end
