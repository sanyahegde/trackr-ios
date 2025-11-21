package repository

import (
	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/database"
	"github.com/trackr/backend-go/internal/models"
)

type PostRepository struct{}

func NewPostRepository() *PostRepository {
	return &PostRepository{}
}

func (r *PostRepository) Create(post *models.Post) error {
	return database.DB.Create(post).Error
}

func (r *PostRepository) FindByID(id uuid.UUID) (*models.Post, error) {
	var post models.Post
	err := database.DB.Preload("User").Preload("Goal").
		Where("id = ?", id).First(&post).Error
	if err != nil {
		return nil, err
	}
	return &post, nil
}

func (r *PostRepository) FindByUserID(userID uuid.UUID, limit int) ([]models.Post, error) {
	var posts []models.Post
	query := database.DB.Preload("User").Preload("Goal").
		Where("user_id = ?", userID).
		Order("created_at DESC")
	if limit > 0 {
		query = query.Limit(limit)
	}
	err := query.Find(&posts).Error
	return posts, err
}

func (r *PostRepository) FindFeed(userIDs []uuid.UUID, limit int) ([]models.Post, error) {
	var posts []models.Post
	err := database.DB.Preload("User").Preload("Goal").
		Where("user_id IN ?", userIDs).
		Order("created_at DESC").
		Limit(limit).
		Find(&posts).Error
	return posts, err
}

func (r *PostRepository) GetAll(limit int) ([]models.Post, error) {
	var posts []models.Post
	err := database.DB.Preload("User").Preload("Goal").
		Order("created_at DESC").
		Limit(limit).
		Find(&posts).Error
	return posts, err
}

func (r *PostRepository) Update(post *models.Post) error {
	return database.DB.Save(post).Error
}

func (r *PostRepository) Delete(id uuid.UUID) error {
	return database.DB.Delete(&models.Post{}, id).Error
}

