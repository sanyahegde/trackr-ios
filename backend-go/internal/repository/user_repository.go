package repository

import (
	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/database"
	"github.com/trackr/backend-go/internal/models"
)

type UserRepository struct{}

func NewUserRepository() *UserRepository {
	return &UserRepository{}
}

func (r *UserRepository) Create(user *models.User) error {
	return database.DB.Create(user).Error
}

func (r *UserRepository) FindByID(id uuid.UUID) (*models.User, error) {
	var user models.User
	err := database.DB.Where("id = ?", id).First(&user).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) FindByEmail(email string) (*models.User, error) {
	var user models.User
	err := database.DB.Where("email = ?", email).First(&user).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) FindByUsername(username string) (*models.User, error) {
	var user models.User
	err := database.DB.Where("username = ?", username).First(&user).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) Search(query string, limit int) ([]models.User, error) {
	var users []models.User
	searchPattern := "%" + query + "%"
	err := database.DB.Where("username ILIKE ? OR name ILIKE ?", searchPattern, searchPattern).
		Limit(limit).
		Order("username ASC").
		Find(&users).Error
	return users, err
}

func (r *UserRepository) Update(user *models.User) error {
	return database.DB.Save(user).Error
}

func (r *UserRepository) Delete(id uuid.UUID) error {
	return database.DB.Delete(&models.User{}, id).Error
}

