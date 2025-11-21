package services

import (
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/models"
	"github.com/trackr/backend-go/internal/repository"
)

type MessageService interface {
	GetOrCreateConversation(user1ID, user2ID uuid.UUID) (*models.Conversation, error)
	GetConversationByID(conversationID, userID uuid.UUID) (*models.Conversation, error)
	GetUserConversations(userID uuid.UUID) ([]models.Conversation, error)
	SendMessage(conversationID, senderID uuid.UUID, content string) (*models.Message, error)
	GetMessages(conversationID, userID uuid.UUID, limit, offset int) ([]models.Message, error)
	MarkAsRead(conversationID, userID uuid.UUID) error
	DeleteMessage(messageID, userID uuid.UUID) error
	IsMutualFriends(user1ID, user2ID uuid.UUID) (bool, error)
}

type messageService struct {
	conversationRepo repository.ConversationRepository
	messageRepo      repository.MessageRepository
	friendshipRepo   *repository.FriendshipRepository
}

func NewMessageService(
	conversationRepo repository.ConversationRepository,
	messageRepo repository.MessageRepository,
	friendshipRepo repository.FriendshipRepository,
) MessageService {
	return &messageService{
		conversationRepo: conversationRepo,
		messageRepo:      messageRepo,
		friendshipRepo:   friendshipRepo,
	}
}

func (s *messageService) IsMutualFriends(user1ID, user2ID uuid.UUID) (bool, error) {
	// Check if user1 follows user2
	follows1, err := s.friendshipRepo.Exists(user1ID, user2ID)
	if err != nil {
		return false, err
	}

	// Check if user2 follows user1
	follows2, err := s.friendshipRepo.Exists(user2ID, user1ID)
	if err != nil {
		return false, err
	}

	return follows1 && follows2, nil
}

func (s *messageService) GetOrCreateConversation(user1ID, user2ID uuid.UUID) (*models.Conversation, error) {
	// Check if they are mutual friends
	isMutual, err := s.IsMutualFriends(user1ID, user2ID)
	if err != nil {
		return nil, err
	}

	if !isMutual {
		return nil, errors.New("users must be mutual friends to message each other")
	}

	return s.conversationRepo.GetOrCreateConversation(user1ID, user2ID)
}

func (s *messageService) GetConversationByID(conversationID, userID uuid.UUID) (*models.Conversation, error) {
	conversation, err := s.conversationRepo.GetConversationByID(conversationID)
	if err != nil {
		return nil, err
	}

	// Verify user is part of this conversation
	if conversation.User1ID != userID && conversation.User2ID != userID {
		return nil, errors.New("user is not part of this conversation")
	}

	return conversation, nil
}

func (s *messageService) GetUserConversations(userID uuid.UUID) ([]models.Conversation, error) {
	return s.conversationRepo.GetUserConversations(userID)
}

func (s *messageService) SendMessage(conversationID, senderID uuid.UUID, content string) (*models.Message, error) {
	// Verify conversation exists and user is part of it
	conversation, err := s.conversationRepo.GetConversationByID(conversationID)
	if err != nil {
		return nil, err
	}

	if conversation.User1ID != senderID && conversation.User2ID != senderID {
		return nil, errors.New("user is not part of this conversation")
	}

	message := &models.Message{
		ConversationID: conversationID,
		SenderID:       senderID,
		Content:        content,
	}

	if err := s.messageRepo.CreateMessage(message); err != nil {
		return nil, err
	}

	return message, nil
}

func (s *messageService) GetMessages(conversationID, userID uuid.UUID, limit, offset int) ([]models.Message, error) {
	// Verify user is part of conversation
	conversation, err := s.conversationRepo.GetConversationByID(conversationID)
	if err != nil {
		return nil, err
	}

	if conversation.User1ID != userID && conversation.User2ID != userID {
		return nil, errors.New("user is not part of this conversation")
	}

	// Mark messages as read when fetching
	_ = s.messageRepo.MarkAsRead(conversationID, userID)

	return s.messageRepo.GetMessagesByConversation(conversationID, limit, offset)
}

func (s *messageService) MarkAsRead(conversationID, userID uuid.UUID) error {
	return s.messageRepo.MarkAsRead(conversationID, userID)
}

func (s *messageService) DeleteMessage(messageID, userID uuid.UUID) error {
	// Verify user owns the message
	message, err := s.messageRepo.GetMessageByID(messageID)
	if err != nil {
		return err
	}

	if message.SenderID != userID {
		return errors.New("user can only delete their own messages")
	}

	return s.messageRepo.DeleteMessage(messageID)
}


