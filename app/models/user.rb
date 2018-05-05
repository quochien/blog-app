class User < ApplicationRecord
  TRENDING_POSTS_NUMBER = 5

  has_many :posts
  has_and_belongs_to_many :friendships,
    class_name: 'User',
    join_table: :friendships,
    foreign_key: :user_id,
    association_foreign_key: :friend_id

  def trending_posts
    trending_ids = posts.joins(%Q{
        LEFT OUTER JOIN likes on posts.id = likes.post_id
        LEFT OUTER JOIN shares on posts.id = shares.post_id
        LEFT OUTER JOIN comments on posts.id = comments.post_id
      })
      .select("posts.id, posts.created_at")
      .group("posts.id, posts.created_at")
      .order(%Q{
        (COUNT(DISTINCT likes.id) + COUNT(DISTINCT shares.id) + COUNT(DISTINCT comments.id)) DESC,
        posts.created_at DESC
      })
      .limit(TRENDING_POSTS_NUMBER)

    Post.where("(id, created_at) IN (?)", trending_ids)
  end
end
