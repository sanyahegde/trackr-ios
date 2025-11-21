package repository

import (
	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/database"
	"github.com/trackr/backend-go/internal/models"
)

type StreakRepository struct{}

func NewStreakRepository() *StreakRepository {
	return &StreakRepository{}
}

func (r *StreakRepository) CreateOrUpdate(streak *models.Streak) error {
	return database.DB.Save(streak).Error
}

func (r *StreakRepository) FindByUserIDAndGoalID(userID, goalID uuid.UUID) (*models.Streak, error) {
	var streak models.Streak
	err := database.DB.Where("user_id = ? AND goal_id = ?", userID, goalID).First(&streak).Error
	if err != nil {
		return nil, err
	}
	return &streak, nil
}

func (r *StreakRepository) FindByUserID(userID uuid.UUID) ([]models.Streak, error) {
	var streaks []models.Streak
	err := database.DB.Preload("Goal").Where("user_id = ?", userID).Find(&streaks).Error
	return streaks, err
}

