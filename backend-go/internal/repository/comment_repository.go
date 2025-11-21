package repository

import (
	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/database"
	"github.com/trackr/backend-go/internal/models"
)

type CommentRepository struct{}

func NewCommentRepository() *CommentRepository {
	return &CommentRepository{}
}

func (r *CommentRepository) Create(comment *models.Comment) error {
	return database.DB.Create(comment).Error
}

func (r *CommentRepository) FindByID(id uuid.UUID) (*models.Comment, error) {
	var comment models.Comment
	err := database.DB.Preload("User").Where("id = ?", id).First(&comment).Error
	if err != nil {
		return nil, err
	}
	return &comment, nil
}

func (r *CommentRepository) FindByPostID(postID uuid.UUID, limit int) ([]models.Comment, error) {
	var comments []models.Comment
	query := database.DB.Preload("User").
		Where("post_id = ?", postID).
		Order("created_at ASC")
	if limit > 0 {
		query = query.Limit(limit)
	}
	err := query.Find(&comments).Error
	return comments, err
}

func (r *CommentRepository) Update(comment *models.Comment) error {
	return database.DB.Save(comment).Error
}

func (r *CommentRepository) Delete(id uuid.UUID) error {
	return database.DB.Delete(&models.Comment{}, id).Error
}

