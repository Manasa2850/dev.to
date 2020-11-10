class PodcastOwnership < ApplicationRecord
    belongs_to :user, foreign_key: 'user_id'
    belongs_to :podcast, foreign_key: 'podcast_id'
end
