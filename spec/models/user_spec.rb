require 'rails_helper'

describe User, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  describe '#trending_posts' do
    let!(:post1) { create(:post, user: user1) }
    let!(:post2) { create(:post, user: user1) }
    let!(:post3) { create(:post, user: user1) }
    let!(:post4) { create(:post, user: user1, created_at: Date.current - 2.days) }
    let!(:post5) { create(:post, user: user1, created_at: Date.current - 1.day) }
    let!(:post6) { create(:post, user: user1, created_at: Date.current) }

    let!(:like1) { create(:like, user: user2, post: post1) }
    let!(:share1) { create(:share, user: user2, post: post1) }
    let!(:comment1) { create(:comment, user: user2, post: post1) }

    let!(:like2) { create(:like, user: user2, post: post2) }
    let!(:share2) { create(:share, user: user2, post: post2) }

    let!(:like3) { create(:like, user: user2, post: post3) }

    it 'returns the trending posts' do
      expect(user1.trending_posts.pluck(:id)).to eq [post1.id, post2.id, post3.id, post6.id, post5.id]
    end
  end
end
