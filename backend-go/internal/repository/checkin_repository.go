package repository

import (
	"time"

	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/database"
	"github.com/trackr/backend-go/internal/models"
)

type CheckInRepository struct{}

func NewCheckInRepository() *CheckInRepository {
	return &CheckInRepository{}
}

func (r *CheckInRepository) Create(checkIn *models.CheckIn) error {
	return database.DB.Create(checkIn).Error
}

func (r *CheckInRepository) FindByID(id uuid.UUID) (*models.CheckIn, error) {
	var checkIn models.CheckIn
	err := database.DB.Preload("Goal").Preload("User").
		Where("id = ?", id).First(&checkIn).Error
	if err != nil {
		return nil, err
	}
	return &checkIn, nil
}

func (r *CheckInRepository) FindByGoalID(goalID uuid.UUID, limit int) ([]models.CheckIn, error) {
	var checkIns []models.CheckIn
	query := database.DB.Preload("User").Where("goal_id = ?", goalID).
		Order("timestamp DESC")
	if limit > 0 {
		query = query.Limit(limit)
	}
	err := query.Find(&checkIns).Error
	return checkIns, err
}

func (r *CheckInRepository) FindByUserID(userID uuid.UUID, limit int) ([]models.CheckIn, error) {
	var checkIns []models.CheckIn
	query := database.DB.Preload("Goal").Where("user_id = ?", userID).
		Order("timestamp DESC")
	if limit > 0 {
		query = query.Limit(limit)
	}
	err := query.Find(&checkIns).Error
	return checkIns, err
}

func (r *CheckInRepository) FindFeed(userID uuid.UUID, followingIDs []uuid.UUID, limit int) ([]models.CheckIn, error) {
	var checkIns []models.CheckIn
	userIDs := append(followingIDs, userID) // Include own check-ins
	err := database.DB.Preload("Goal").Preload("User").
		Where("user_id IN ?", userIDs).
		Order("timestamp DESC").
		Limit(limit).
		Find(&checkIns).Error
	return checkIns, err
}

func (r *CheckInRepository) GetLatestByGoal(goalID uuid.UUID) (*models.CheckIn, error) {
	var checkIn models.CheckIn
	err := database.DB.Where("goal_id = ?", goalID).
		Order("timestamp DESC").
		First(&checkIn).Error
	if err != nil {
		return nil, err
	}
	return &checkIn, nil
}

func (r *CheckInRepository) GetCheckInsBetween(goalID uuid.UUID, start, end time.Time) ([]models.CheckIn, error) {
	var checkIns []models.CheckIn
	err := database.DB.Where("goal_id = ? AND timestamp >= ? AND timestamp <= ?", goalID, start, end).
		Order("timestamp ASC").
		Find(&checkIns).Error
	return checkIns, err
}

func (r *CheckInRepository) Delete(id uuid.UUID) error {
	return database.DB.Delete(&models.CheckIn{}, id).Error
}

