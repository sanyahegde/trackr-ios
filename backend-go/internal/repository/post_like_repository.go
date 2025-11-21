package repository

import (
	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/database"
	"github.com/trackr/backend-go/internal/models"
)

type PostLikeRepository struct{}

func NewPostLikeRepository() *PostLikeRepository {
	return &PostLikeRepository{}
}

func (r *PostLikeRepository) Create(like *models.PostLike) error {
	return database.DB.Create(like).Error
}

func (r *PostLikeRepository) Delete(postID, userID uuid.UUID) error {
	return database.DB.Where("post_id = ? AND user_id = ?", postID, userID).
		Delete(&models.PostLike{}).Error
}

func (r *PostLikeRepository) Exists(postID, userID uuid.UUID) (bool, error) {
	var count int64
	err := database.DB.Model(&models.PostLike{}).
		Where("post_id = ? AND user_id = ?", postID, userID).
		Count(&count).Error
	return count > 0, err
}

func (r *PostLikeRepository) GetLikesByPostID(postID uuid.UUID) ([]models.PostLike, error) {
	var likes []models.PostLike
	err := database.DB.Preload("User").
		Where("post_id = ?", postID).
		Order("created_at DESC").
		Find(&likes).Error
	return likes, err
}

