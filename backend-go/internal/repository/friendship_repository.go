package repository

import (
	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/database"
	"github.com/trackr/backend-go/internal/models"
)

type FriendshipRepository struct{}

func NewFriendshipRepository() *FriendshipRepository {
	return &FriendshipRepository{}
}

func (r *FriendshipRepository) Create(friendship *models.Friendship) error {
	return database.DB.Create(friendship).Error
}

func (r *FriendshipRepository) Delete(followerID, followeeID uuid.UUID) error {
	return database.DB.Where("follower_id = ? AND followee_id = ?", followerID, followeeID).
		Delete(&models.Friendship{}).Error
}

func (r *FriendshipRepository) Exists(followerID, followeeID uuid.UUID) (bool, error) {
	var count int64
	err := database.DB.Model(&models.Friendship{}).
		Where("follower_id = ? AND followee_id = ?", followerID, followeeID).
		Count(&count).Error
	return count > 0, err
}

func (r *FriendshipRepository) GetFollowers(userID uuid.UUID) ([]models.User, error) {
	var users []models.User
	err := database.DB.Table("friendships").
		Select("users.*").
		Joins("JOIN users ON users.id = friendships.follower_id").
		Where("friendships.followee_id = ?", userID).
		Find(&users).Error
	return users, err
}

func (r *FriendshipRepository) GetFollowing(userID uuid.UUID) ([]models.User, error) {
	var users []models.User
	err := database.DB.Table("friendships").
		Select("users.*").
		Joins("JOIN users ON users.id = friendships.followee_id").
		Where("friendships.follower_id = ?", userID).
		Find(&users).Error
	return users, err
}

