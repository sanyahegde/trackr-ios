package repository

import (
	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/database"
	"github.com/trackr/backend-go/internal/models"
)

type GoalRepository struct{}

func NewGoalRepository() *GoalRepository {
	return &GoalRepository{}
}

func (r *GoalRepository) Create(goal *models.Goal) error {
	return database.DB.Create(goal).Error
}

func (r *GoalRepository) FindByID(id uuid.UUID) (*models.Goal, error) {
	var goal models.Goal
	err := database.DB.Preload("User").Where("id = ?", id).First(&goal).Error
	if err != nil {
		return nil, err
	}
	return &goal, nil
}

func (r *GoalRepository) FindByUserID(userID uuid.UUID) ([]models.Goal, error) {
	var goals []models.Goal
	err := database.DB.Where("user_id = ?", userID).
		Order("created_at DESC").
		Find(&goals).Error
	return goals, err
}

func (r *GoalRepository) Update(goal *models.Goal) error {
	return database.DB.Save(goal).Error
}

func (r *GoalRepository) Delete(id uuid.UUID) error {
	return database.DB.Delete(&models.Goal{}, id).Error
}

func (r *GoalRepository) FindByUserIDAndID(userID, goalID uuid.UUID) (*models.Goal, error) {
	var goal models.Goal
	err := database.DB.Where("id = ? AND user_id = ?", goalID, userID).First(&goal).Error
	if err != nil {
		return nil, err
	}
	return &goal, nil
}

