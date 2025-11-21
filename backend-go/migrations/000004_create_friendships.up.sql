CREATE TABLE IF NOT EXISTS friendships (
    follower_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    followee_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, followee_id),
    CHECK (follower_id != followee_id)
);

CREATE INDEX idx_friendships_follower_id ON friendships(follower_id);
CREATE INDEX idx_friendships_followee_id ON friendships(followee_id);

