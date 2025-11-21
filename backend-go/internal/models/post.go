package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// Post represents a social media post (like Instagram/Strava)
type Post struct {
	ID          uuid.UUID `gorm:"type:uuid;primaryKey;default:gen_random_uuid()" json:"id"`
	UserID      uuid.UUID `gorm:"type:uuid;not null;index" json:"user_id"`
	GoalID      *uuid.UUID `gorm:"type:uuid;index" json:"goal_id,omitempty"` // Optional - post can be about a goal
	Caption     string    `gorm:"type:text" json:"caption"`
	ImageURL    string    `json:"image_url,omitempty"` // URL to uploaded image
	LikesCount  int       `gorm:"default:0" json:"likes_count"`
	CommentsCount int     `gorm:"default:0" json:"comments_count"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`

	// Relationships
	User     User      `gorm:"foreignKey:UserID" json:"user,omitempty"`
	Goal     *Goal     `gorm:"foreignKey:GoalID" json:"goal,omitempty"`
	Likes    []PostLike `gorm:"foreignKey:PostID" json:"likes,omitempty"`
	Comments []Comment `gorm:"foreignKey:PostID" json:"comments,omitempty"`
}

// PostLike represents a like on a post
type PostLike struct {
	ID        uuid.UUID `gorm:"type:uuid;primaryKey;default:gen_random_uuid()" json:"id"`
	PostID    uuid.UUID `gorm:"type:uuid;not null;index" json:"post_id"`
	UserID    uuid.UUID `gorm:"type:uuid;not null;index" json:"user_id"`
	CreatedAt time.Time `json:"created_at"`

	// Relationships
	Post Post `gorm:"foreignKey:PostID" json:"post,omitempty"`
	User User `gorm:"foreignKey:UserID" json:"user,omitempty"`
}

// Comment represents a comment on a post
type Comment struct {
	ID        uuid.UUID `gorm:"type:uuid;primaryKey;default:gen_random_uuid()" json:"id"`
	PostID    uuid.UUID `gorm:"type:uuid;not null;index" json:"post_id"`
	UserID    uuid.UUID `gorm:"type:uuid;not null;index" json:"user_id"`
	Text      string    `gorm:"type:text;not null" json:"text"`
	LikesCount int      `gorm:"default:0" json:"likes_count"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`

	// Relationships
	Post Post `gorm:"foreignKey:PostID" json:"post,omitempty"`
	User User `gorm:"foreignKey:UserID" json:"user,omitempty"`
}

func (Post) TableName() string {
	return "posts"
}

func (PostLike) TableName() string {
	return "post_likes"
}

func (Comment) TableName() string {
	return "comments"
}

// BeforeCreate hooks
func (p *Post) BeforeCreate(tx *gorm.DB) error {
	if p.ID == uuid.Nil {
		p.ID = uuid.New()
	}
	return nil
}

func (pl *PostLike) BeforeCreate(tx *gorm.DB) error {
	if pl.ID == uuid.Nil {
		pl.ID = uuid.New()
	}
	return nil
}

func (c *Comment) BeforeCreate(tx *gorm.DB) error {
	if c.ID == uuid.Nil {
		c.ID = uuid.New()
	}
	return nil
}

