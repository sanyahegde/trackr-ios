package services

import (
	"time"

	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/models"
	"github.com/trackr/backend-go/internal/repository"
)

type CheckInService struct {
	checkInRepo *repository.CheckInRepository
	goalRepo    *repository.GoalRepository
	streakSvc   *StreakService
}

func NewCheckInService(
	checkInRepo *repository.CheckInRepository,
	goalRepo *repository.GoalRepository,
	streakSvc *StreakService,
) *CheckInService {
	return &CheckInService{
		checkInRepo: checkInRepo,
		goalRepo:    goalRepo,
		streakSvc:   streakSvc,
	}
}

type CreateCheckInRequest struct {
	Note  string
	Value *float64
}

func (s *CheckInService) CreateCheckIn(userID, goalID uuid.UUID, req CreateCheckInRequest) (*models.CheckIn, error) {
	// Verify goal belongs to user
	goal, err := s.goalRepo.FindByUserIDAndID(userID, goalID)
	if err != nil {
		return nil, err
	}

	checkIn := &models.CheckIn{
		GoalID:    goalID,
		UserID:    userID,
		Note:      req.Note,
		Value:     req.Value,
		Timestamp: time.Now(),
	}

	if err := s.checkInRepo.Create(checkIn); err != nil {
		return nil, err
	}

	// Update streak
	if err := s.streakSvc.UpdateStreak(checkIn); err != nil {
		// Log error but don't fail the check-in
		// TODO: Add logging
	}

	return checkIn, nil
}

func (s *CheckInService) GetCheckIns(goalID uuid.UUID, limit int) ([]models.CheckIn, error) {
	return s.checkInRepo.FindByGoalID(goalID, limit)
}

func (s *CheckInService) GetFeed(userID uuid.UUID, followingIDs []uuid.UUID, limit int) ([]models.CheckIn, error) {
	return s.checkInRepo.FindFeed(userID, followingIDs, limit)
}

