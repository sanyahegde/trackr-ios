package repository

import (
	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/database"
	"github.com/trackr/backend-go/internal/models"
	"gorm.io/gorm"
)

type MessageRepository interface {
	CreateMessage(message *models.Message) error
	GetMessagesByConversation(conversationID uuid.UUID, limit, offset int) ([]models.Message, error)
	GetMessageByID(messageID uuid.UUID) (*models.Message, error)
	MarkAsRead(conversationID, userID uuid.UUID) error
	DeleteMessage(messageID uuid.UUID) error
	GetUnreadCount(conversationID, userID uuid.UUID) (int64, error)
}

type messageRepository struct {
	db *gorm.DB
}

func NewMessageRepository() MessageRepository {
	return &messageRepository{
		db: database.GetDB(),
	}
}

func (r *messageRepository) CreateMessage(message *models.Message) error {
	if err := r.db.Create(message).Error; err != nil {
		return err
	}

	// Update conversation's updated_at timestamp
	r.db.Model(&models.Conversation{}).
		Where("id = ?", message.ConversationID).
		Update("updated_at", message.CreatedAt)

	return r.db.Preload("Sender").First(message, "id = ?", message.ID).Error
}

func (r *messageRepository) GetMessagesByConversation(conversationID uuid.UUID, limit, offset int) ([]models.Message, error) {
	var messages []models.Message
	query := r.db.Where("conversation_id = ?", conversationID).
		Preload("Sender").
		Order("created_at DESC")

	if limit > 0 {
		query = query.Limit(limit)
	}
	if offset > 0 {
		query = query.Offset(offset)
	}

	err := query.Find(&messages).Error
	
	// Reverse to show oldest first
	for i, j := 0, len(messages)-1; i < j; i, j = i+1, j-1 {
		messages[i], messages[j] = messages[j], messages[i]
	}

	return messages, err
}

func (r *messageRepository) GetMessageByID(messageID uuid.UUID) (*models.Message, error) {
	var message models.Message
	err := r.db.Preload("Sender").First(&message, "id = ?", messageID).Error
	if err != nil {
		return nil, err
	}
	return &message, nil
}

func (r *messageRepository) MarkAsRead(conversationID, userID uuid.UUID) error {
	now := r.db.NowFunc()
	return r.db.Model(&models.Message{}).
		Where("conversation_id = ? AND sender_id != ? AND read_at IS NULL", conversationID, userID).
		Update("read_at", now).Error
}

func (r *messageRepository) DeleteMessage(messageID uuid.UUID) error {
	return r.db.Delete(&models.Message{}, "id = ?", messageID).Error
}

func (r *messageRepository) GetUnreadCount(conversationID, userID uuid.UUID) (int64, error) {
	var count int64
	err := r.db.Model(&models.Message{}).
		Where("conversation_id = ? AND sender_id != ? AND read_at IS NULL", conversationID, userID).
		Count(&count).Error
	return count, err
}


