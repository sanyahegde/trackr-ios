package services

import (
	"time"

	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/models"
	"github.com/trackr/backend-go/internal/repository"
)

type StreakService struct {
	streakRepo   *repository.StreakRepository
	checkInRepo  *repository.CheckInRepository
}

func NewStreakService(streakRepo *repository.StreakRepository, checkInRepo *repository.CheckInRepository) *StreakService {
	return &StreakService{
		streakRepo:  streakRepo,
		checkInRepo: checkInRepo,
	}
}

// UpdateStreak calculates and updates streak for a check-in
func (s *StreakService) UpdateStreak(checkIn *models.CheckIn) error {
	// Get or create streak
	streak, err := s.streakRepo.FindByUserIDAndGoalID(checkIn.UserID, checkIn.GoalID)
	if err != nil {
		// Streak doesn't exist, create new one
		streak = &models.Streak{
			UserID:          checkIn.UserID,
			GoalID:          checkIn.GoalID,
			CurrentStreak:   1,
			LongestStreak:   1,
			LastCheckInDate: &checkIn.Timestamp,
		}
		return s.streakRepo.CreateOrUpdate(streak)
	}

	// Check if this check-in is on a consecutive day
	checkInDate := time.Date(
		checkIn.Timestamp.Year(),
		checkIn.Timestamp.Month(),
		checkIn.Timestamp.Day(),
		0, 0, 0, 0,
		time.UTC,
	)

	if streak.LastCheckInDate == nil {
		// First check-in for this streak
		streak.CurrentStreak = 1
		streak.LongestStreak = 1
		streak.LastCheckInDate = &checkIn.Timestamp
	} else {
		lastCheckInDate := time.Date(
			streak.LastCheckInDate.Year(),
			streak.LastCheckInDate.Month(),
			streak.LastCheckInDate.Day(),
			0, 0, 0, 0,
			time.UTC,
		)

		daysDiff := int(checkInDate.Sub(lastCheckInDate).Hours() / 24)

		if daysDiff == 0 {
			// Same day, don't update streak
			return nil
		} else if daysDiff == 1 {
			// Consecutive day, increment streak
			streak.CurrentStreak++
			if streak.CurrentStreak > streak.LongestStreak {
				streak.LongestStreak = streak.CurrentStreak
			}
			streak.LastCheckInDate = &checkIn.Timestamp
		} else {
			// Streak broken, reset to 1
			streak.CurrentStreak = 1
			streak.LastCheckInDate = &checkIn.Timestamp
		}
	}

	return s.streakRepo.CreateOrUpdate(streak)
}

func (s *StreakService) GetStreaks(userID uuid.UUID) ([]models.Streak, error) {
	return s.streakRepo.FindByUserID(userID)
}

func (s *StreakService) GetStreak(userID, goalID uuid.UUID) (*models.Streak, error) {
	return s.streakRepo.FindByUserIDAndGoalID(userID, goalID)
}

