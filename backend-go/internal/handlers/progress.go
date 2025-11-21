package handlers

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/trackr/backend-go/internal/database"
	"github.com/trackr/backend-go/internal/models"
	"gorm.io/gorm"
)

type ProgressHandler struct{}

func NewProgressHandler() *ProgressHandler {
	return &ProgressHandler{}
}

// CreateProgressRequest represents the request to create a progress update
type CreateProgressRequest struct {
	GoalID  uint     `json:"goal_id" binding:"required"`
	Value   *float64 `json:"value,omitempty"`
	Note    string   `json:"note,omitempty"`
	Timestamp *time.Time `json:"timestamp,omitempty"`
}

// CreateProgress creates a new progress update
func (h *ProgressHandler) CreateProgress(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req CreateProgressRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Verify goal belongs to user
	var goal models.Goal
	if err := database.DB.Where("id = ? AND user_id = ?", req.GoalID, userID).First(&goal).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Goal not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}

	// Use provided timestamp or current time
	timestamp := time.Now()
	if req.Timestamp != nil {
		timestamp = *req.Timestamp
	}

	progress := models.ProgressUpdate{
		GoalID:    req.GoalID,
		UserID:    userID.(uint),
		Value:     req.Value,
		Note:      req.Note,
		Timestamp: timestamp,
	}

	if err := database.DB.Create(&progress).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create progress update"})
		return
	}

	// Load relationships
	database.DB.Preload("Goal").Preload("User").First(&progress, progress.ID)

	c.JSON(http.StatusCreated, progress)
}

// GetProgress retrieves progress updates for a goal
func (h *ProgressHandler) GetProgress(c *gin.Context) {
	userID, _ := c.Get("user_id")
	goalID := c.Param("goal_id")

	// Verify goal belongs to user
	var goal models.Goal
	if err := database.DB.Where("id = ? AND user_id = ?", goalID, userID).First(&goal).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Goal not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}

	var updates []models.ProgressUpdate
	if err := database.DB.Where("goal_id = ?", goalID).Order("timestamp DESC").Find(&updates).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch progress updates"})
		return
	}

	c.JSON(http.StatusOK, updates)
}

// DeleteProgress deletes a progress update
func (h *ProgressHandler) DeleteProgress(c *gin.Context) {
	userID, _ := c.Get("user_id")
	progressID := c.Param("id")

	result := database.DB.Where("id = ? AND user_id = ?", progressID, userID).Delete(&models.ProgressUpdate{})
	if result.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete progress update"})
		return
	}

	if result.RowsAffected == 0 {
		c.JSON(http.StatusNotFound, gin.H{"error": "Progress update not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Progress update deleted successfully"})
}



