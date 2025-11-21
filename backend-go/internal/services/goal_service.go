package services

import (
	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/models"
	"github.com/trackr/backend-go/internal/repository"
)

type GoalService struct {
	goalRepo *repository.GoalRepository
}

func NewGoalService(goalRepo *repository.GoalRepository) *GoalService {
	return &GoalService{goalRepo: goalRepo}
}

type CreateGoalRequest struct {
	Title       string
	Description string
	Frequency   string
}

type UpdateGoalRequest struct {
	Title       *string
	Description *string
	Frequency   *string
}

func (s *GoalService) CreateGoal(userID uuid.UUID, req CreateGoalRequest) (*models.Goal, error) {
	goal := &models.Goal{
		UserID:      userID,
		Title:       req.Title,
		Description: req.Description,
		Frequency:   req.Frequency,
	}

	if err := s.goalRepo.Create(goal); err != nil {
		return nil, err
	}

	return goal, nil
}

func (s *GoalService) GetGoals(userID uuid.UUID) ([]models.Goal, error) {
	return s.goalRepo.FindByUserID(userID)
}

func (s *GoalService) GetGoal(userID, goalID uuid.UUID) (*models.Goal, error) {
	return s.goalRepo.FindByUserIDAndID(userID, goalID)
}

func (s *GoalService) UpdateGoal(userID, goalID uuid.UUID, req UpdateGoalRequest) (*models.Goal, error) {
	goal, err := s.goalRepo.FindByUserIDAndID(userID, goalID)
	if err != nil {
		return nil, err
	}

	if req.Title != nil {
		goal.Title = *req.Title
	}
	if req.Description != nil {
		goal.Description = *req.Description
	}
	if req.Frequency != nil {
		goal.Frequency = *req.Frequency
	}

	if err := s.goalRepo.Update(goal); err != nil {
		return nil, err
	}

	return goal, nil
}

func (s *GoalService) DeleteGoal(userID, goalID uuid.UUID) error {
	// Verify goal belongs to user
	_, err := s.goalRepo.FindByUserIDAndID(userID, goalID)
	if err != nil {
		return err
	}

	return s.goalRepo.Delete(goalID)
}

