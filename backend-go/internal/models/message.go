package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// Conversation represents a conversation between two users
type Conversation struct {
	ID        uuid.UUID `gorm:"type:uuid;primaryKey;default:gen_random_uuid()" json:"id"`
	User1ID   uuid.UUID `gorm:"type:uuid;not null;index" json:"user1_id"`
	User2ID   uuid.UUID `gorm:"type:uuid;not null;index" json:"user2_id"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`

	// Relationships
	User1  User     `gorm:"foreignKey:User1ID" json:"user1,omitempty"`
	User2  User     `gorm:"foreignKey:User2ID" json:"user2,omitempty"`
	Messages []Message `gorm:"foreignKey:ConversationID" json:"messages,omitempty"`
	
	// Virtual fields for response
	LastMessage *Message `gorm:"-" json:"last_message,omitempty"`
	UnreadCount int      `gorm:"-" json:"unread_count"`
}

// Message represents a message in a conversation
type Message struct {
	ID             uuid.UUID `gorm:"type:uuid;primaryKey;default:gen_random_uuid()" json:"id"`
	ConversationID uuid.UUID `gorm:"type:uuid;not null;index" json:"conversation_id"`
	SenderID       uuid.UUID `gorm:"type:uuid;not null;index" json:"sender_id"`
	Content        string    `gorm:"type:text;not null" json:"content"`
	ReadAt         *time.Time `json:"read_at,omitempty"`
	CreatedAt      time.Time `json:"created_at"`
	UpdatedAt      time.Time `json:"updated_at"`
	DeletedAt      gorm.DeletedAt `gorm:"index" json:"-"`

	// Relationships
	Conversation Conversation `gorm:"foreignKey:ConversationID" json:"conversation,omitempty"`
	Sender       User         `gorm:"foreignKey:SenderID" json:"sender,omitempty"`
}

// TableName overrides GORM's default table naming
func (Conversation) TableName() string {
	return "conversations"
}

func (Message) TableName() string {
	return "messages"
}


