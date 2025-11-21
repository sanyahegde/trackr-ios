package database

import (
	"fmt"
	"log"

	"github.com/trackr/backend-go/internal/config"
	"github.com/trackr/backend-go/internal/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

var DB *gorm.DB

// Connect initializes the database connection
func Connect(cfg *config.Config) error {
	dsn := cfg.Database.DSN()

	var err error
	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})

	if err != nil {
		return fmt.Errorf("failed to connect to database: %w", err)
	}

	log.Println("✅ Database connection established")

	// Auto-migrate models
	if err := AutoMigrate(); err != nil {
		return fmt.Errorf("failed to auto-migrate: %w", err)
	}

	return nil
}

// AutoMigrate runs database migrations
func AutoMigrate() error {
	return DB.AutoMigrate(
		&models.User{},
		&models.Goal{},
		&models.CheckIn{},
		&models.Friendship{},
		&models.Streak{},
		&models.Challenge{},
		&models.ChallengeParticipant{},
		&models.Achievement{},
		&models.ActivityFeed{},
		&models.Post{},
		&models.PostLike{},
		&models.Comment{},
		&models.Conversation{},
		&models.Message{},
	)
}

// Close closes the database connection
func Close() error {
	sqlDB, err := DB.DB()
	if err != nil {
		return err
	}
	return sqlDB.Close()
}

// GetDB returns the database instance
func GetDB() *gorm.DB {
	return DB
}


