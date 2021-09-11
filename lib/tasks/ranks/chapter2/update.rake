namespace :ranks do
  namespace :chapter2 do
    # バッチ処理の概要 bin/rails -vT 実行時にも表示される
    desc 'chapter2 ゲーム内のユーザーランキング情報を更新する'
    # :environmentタスクの後、:updateタスクが実行される
    task update: :environment do
      # 現在のランキング情報をリセット
      Rank.delete_all

      # ユーザーごとにスコアの合計を計算する
      user_total_scores = User.all.map do |user|
        { user_id: user.id, total_score: user.user_scores.sum(&:score)}
      end

      # ユーザーごとのスコア合計の降順に並べ替え、そこからランキング情報を作成する
      sorted_total_score_groups = user_total_scores
                    .group_by { |score| score[:total_score] }
                    .sort_by { |score, _| score * -1 }
                    .to_h
                    .values

      sorted_total_score_groups.each.with_index(1) do |scores, index|
        scores.each do |total_score|
          Rank.create(user_id: total_score[:user_id], rank: index, score: total_score[:total_score])
        end
      end
    end
  end
end
