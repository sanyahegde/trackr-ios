package handlers

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/services"
)

type CheckInHandler struct {
	checkInService *services.CheckInService
}

func NewCheckInHandler(checkInService *services.CheckInService) *CheckInHandler {
	return &CheckInHandler{checkInService: checkInService}
}

type CreateCheckInRequest struct {
	Note  string   `json:"note,omitempty"`
	Value *float64 `json:"value,omitempty"`
}

// CreateCheckIn creates a new check-in for a goal
func (h *CheckInHandler) CreateCheckIn(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "user not authenticated"})
		return
	}

	goalIDStr := c.Param("id")
	goalID, err := uuid.Parse(goalIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid goal ID"})
		return
	}

	var req CreateCheckInRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	checkIn, err := h.checkInService.CreateCheckIn(userID.(uuid.UUID), goalID, services.CreateCheckInRequest{
		Note:  req.Note,
		Value: req.Value,
	})

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, checkIn)
}

// GetCheckIns gets check-ins for a goal
func (h *CheckInHandler) GetCheckIns(c *gin.Context) {
	goalIDStr := c.Param("id")
	goalID, err := uuid.Parse(goalIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid goal ID"})
		return
	}

	limitStr := c.DefaultQuery("limit", "50")
	limit, err := strconv.Atoi(limitStr)
	if err != nil || limit < 1 || limit > 100 {
		limit = 50
	}

	checkIns, err := h.checkInService.GetCheckIns(goalID, limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, checkIns)
}

// GetFeed gets the activity feed
func (h *CheckInHandler) GetFeed(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "user not authenticated"})
		return
	}

	// TODO: Get following IDs from friendship service
	followingIDs := []uuid.UUID{} // Empty for now - friends-only feed not implemented yet

	limitStr := c.DefaultQuery("limit", "50")
	limit, err := strconv.Atoi(limitStr)
	if err != nil || limit < 1 || limit > 100 {
		limit = 50
	}

	checkIns, err := h.checkInService.GetFeed(userID.(uuid.UUID), followingIDs, limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, checkIns)
}

