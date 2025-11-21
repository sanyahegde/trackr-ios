package repository

import (
	"errors"

	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/database"
	"github.com/trackr/backend-go/internal/models"
	"gorm.io/gorm"
)

type ConversationRepository interface {
	GetOrCreateConversation(user1ID, user2ID uuid.UUID) (*models.Conversation, error)
	GetConversationByID(conversationID uuid.UUID) (*models.Conversation, error)
	GetUserConversations(userID uuid.UUID) ([]models.Conversation, error)
	DeleteConversation(conversationID uuid.UUID) error
}

type conversationRepository struct {
	db *gorm.DB
}

func NewConversationRepository() ConversationRepository {
	return &conversationRepository{
		db: database.GetDB(),
	}
}

func (r *conversationRepository) GetOrCreateConversation(user1ID, user2ID uuid.UUID) (*models.Conversation, error) {
	// Ensure consistent ordering (user1_id < user2_id)
	if user1ID.String() > user2ID.String() {
		user1ID, user2ID = user2ID, user1ID
	}

	var conversation models.Conversation
	err := r.db.Where("user1_id = ? AND user2_id = ?", user1ID, user2ID).First(&conversation).Error
	
	if errors.Is(err, gorm.ErrRecordNotFound) {
		// Create new conversation
		conversation = models.Conversation{
			User1ID: user1ID,
			User2ID: user2ID,
		}
		if err := r.db.Create(&conversation).Error; err != nil {
			return nil, err
		}
	} else if err != nil {
		return nil, err
	}

	return &conversation, nil
}

func (r *conversationRepository) GetConversationByID(conversationID uuid.UUID) (*models.Conversation, error) {
	var conversation models.Conversation
	err := r.db.Preload("User1").Preload("User2").First(&conversation, "id = ?", conversationID).Error
	if err != nil {
		return nil, err
	}
	return &conversation, nil
}

func (r *conversationRepository) GetUserConversations(userID uuid.UUID) ([]models.Conversation, error) {
	var conversations []models.Conversation
	err := r.db.
		Where("user1_id = ? OR user2_id = ?", userID, userID).
		Preload("User1").
		Preload("User2").
		Order("updated_at DESC").
		Find(&conversations).Error
	
	if err != nil {
		return nil, err
	}

	// Load last message and unread count for each conversation
	for i := range conversations {
		var lastMessage models.Message
		r.db.Where("conversation_id = ?", conversations[i].ID).
			Order("created_at DESC").
			First(&lastMessage)
		conversations[i].LastMessage = &lastMessage

		var unreadCount int64
		r.db.Model(&models.Message{}).
			Where("conversation_id = ? AND sender_id != ? AND read_at IS NULL", conversations[i].ID, userID).
			Count(&unreadCount)
		conversations[i].UnreadCount = int(unreadCount)
	}

	return conversations, nil
}

func (r *conversationRepository) DeleteConversation(conversationID uuid.UUID) error {
	return r.db.Delete(&models.Conversation{}, "id = ?", conversationID).Error
}


