package services

import (
	"errors"

	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/models"
	"github.com/trackr/backend-go/internal/repository"
)

type UserService struct {
	userRepo       *repository.UserRepository
	friendshipRepo *repository.FriendshipRepository
}

func NewUserService(userRepo *repository.UserRepository, friendshipRepo *repository.FriendshipRepository) *UserService {
	return &UserService{
		userRepo:       userRepo,
		friendshipRepo: friendshipRepo,
	}
}

func (s *UserService) GetUser(userID uuid.UUID) (*models.User, error) {
	user, err := s.userRepo.FindByID(userID)
	if err != nil {
		return nil, errors.New("user not found")
	}
	return user, nil
}

func (s *UserService) GetFollowers(userID uuid.UUID) ([]models.User, error) {
	return s.friendshipRepo.GetFollowers(userID)
}

func (s *UserService) GetFollowing(userID uuid.UUID) ([]models.User, error) {
	return s.friendshipRepo.GetFollowing(userID)
}

func (s *UserService) FollowUser(followerID, followeeID uuid.UUID) error {
	if followerID == followeeID {
		return errors.New("cannot follow yourself")
	}

	// Check if already following
	exists, err := s.friendshipRepo.Exists(followerID, followeeID)
	if err != nil {
		return errors.New("failed to check friendship")
	}
	if exists {
		return errors.New("already following this user")
	}

	friendship := &models.Friendship{
		FollowerID: followerID,
		FolloweeID: followeeID,
	}

	return s.friendshipRepo.Create(friendship)
}

func (s *UserService) UnfollowUser(followerID, followeeID uuid.UUID) error {
	return s.friendshipRepo.Delete(followerID, followeeID)
}

func (s *UserService) SearchUsers(query string, limit int) ([]models.User, error) {
	if query == "" {
		return []models.User{}, nil
	}
	return s.userRepo.Search(query, limit)
}

