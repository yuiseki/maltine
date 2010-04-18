class Token < ActiveRecord::Base
  belongs_to :user


  def self.create_tokens(num)
    # num個のtokenを作り出す
    # 固定長のランダムな文字列を生成、とりあえず５文字
    alphabet = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    num.times do |i|
      token = Array.new(5).fill{alphabet[rand(alphabet.size)]}.join
      @token = self.new({:token => token})
      @token.save
    end
  end


end
