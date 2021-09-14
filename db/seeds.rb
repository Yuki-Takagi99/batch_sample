# データのリセット
Rank.delete_all
User.delete_all

# テストデータの作成
user_amount = ENV['USER_AMOUNT'].to_i

User.transaction do
  1.upto(user_amount) do |i|
    user = User.create(id: i, name: "#{i}人目のゲームユーザー")
    # テストデータ ユーザーごとの得点
    rand(30).times do
      UserScore.create(user_id: user.id, score: rand(1..100), received_at: Time.current.ago(rand(0..60).days))
    end
  end
end