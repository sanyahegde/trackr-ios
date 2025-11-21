package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/models"
	"github.com/trackr/backend-go/internal/services"
)

type StreakHandler struct {
	streakService *services.StreakService
}

func NewStreakHandler(streakService *services.StreakService) *StreakHandler {
	return &StreakHandler{streakService: streakService}
}

// GetStreaks gets all streaks for the current user
func (h *StreakHandler) GetStreaks(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "user not authenticated"})
		return
	}

	streaks, err := h.streakService.GetStreaks(userID.(uuid.UUID))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, streaks)
}

// GetStreak gets a streak for a specific goal
func (h *StreakHandler) GetStreak(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "user not authenticated"})
		return
	}

	goalIDStr := c.Param("goal_id")
	goalID, err := uuid.Parse(goalIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid goal ID"})
		return
	}

	streak, err := h.streakService.GetStreak(userID.(uuid.UUID), goalID)
	if err != nil {
		// Streak might not exist yet, return empty streak
		streak = &models.Streak{
			UserID:        userID.(uuid.UUID),
			GoalID:        goalID,
			CurrentStreak: 0,
			LongestStreak: 0,
		}
	}

	c.JSON(http.StatusOK, streak)
}

