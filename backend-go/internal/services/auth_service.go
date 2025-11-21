package services

import (
	"errors"

	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/config"
	"github.com/trackr/backend-go/internal/models"
	"github.com/trackr/backend-go/internal/repository"
	"github.com/trackr/backend-go/pkg/jwt"
	pwdhash "github.com/trackr/backend-go/pkg/password"
)

type AuthService struct {
	userRepo *repository.UserRepository
	config   *config.Config
}

func NewAuthService(userRepo *repository.UserRepository, cfg *config.Config) *AuthService {
	return &AuthService{
		userRepo: userRepo,
		config:   cfg,
	}
}

type SignupRequest struct {
	Email    string
	Name     string
	Username string
	Password string
}

type SignupResult struct {
	User         *models.User
	AccessToken  string
	RefreshToken string
}

type LoginResult struct {
	User         *models.User
	AccessToken  string
	RefreshToken string
}

func (s *AuthService) Signup(req SignupRequest) (*SignupResult, error) {
	// Check if email already exists
	existingUser, _ := s.userRepo.FindByEmail(req.Email)
	if existingUser != nil {
		return nil, errors.New("user with this email already exists")
	}

	// Check if username already exists
	existingUser, _ = s.userRepo.FindByUsername(req.Username)
	if existingUser != nil {
		return nil, errors.New("username already taken")
	}

	// Hash password
	hashedPassword, err := pwdhash.Hash(req.Password)
	if err != nil {
		return nil, errors.New("failed to hash password")
	}

	// Create user
	user := &models.User{
		Email:        req.Email,
		Name:         req.Name,
		Username:     req.Username,
		PasswordHash: hashedPassword,
	}

	if err := s.userRepo.Create(user); err != nil {
		return nil, errors.New("failed to create user")
	}

	// Generate tokens
	accessToken, err := jwt.GenerateToken(user.ID, user.Email, s.config.JWT.Secret, s.config.JWT.ExpiryHours)
	if err != nil {
		return nil, errors.New("failed to generate access token")
	}

	refreshToken, err := jwt.GenerateRefreshToken(user.ID, s.config.JWT.Secret, s.config.JWT.RefreshExpiryHours)
	if err != nil {
		return nil, errors.New("failed to generate refresh token")
	}

	return &SignupResult{
		User:         user,
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
	}, nil
}

func (s *AuthService) Login(email, password string) (*LoginResult, error) {
	// Find user
	user, err := s.userRepo.FindByEmail(email)
	if err != nil {
		return nil, errors.New("invalid email or password")
	}

	// Check password
	if !pwdhash.Check(password, user.PasswordHash) {
		return nil, errors.New("invalid email or password")
	}

	// Generate tokens
	accessToken, err := jwt.GenerateToken(user.ID, user.Email, s.config.JWT.Secret, s.config.JWT.ExpiryHours)
	if err != nil {
		return nil, errors.New("failed to generate access token")
	}

	refreshToken, err := jwt.GenerateRefreshToken(user.ID, s.config.JWT.Secret, s.config.JWT.RefreshExpiryHours)
	if err != nil {
		return nil, errors.New("failed to generate refresh token")
	}

	return &LoginResult{
		User:         user,
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
	}, nil
}

func (s *AuthService) RefreshToken(refreshTokenString string) (*LoginResult, error) {
	// Validate refresh token
	claims, err := jwt.ValidateToken(refreshTokenString, s.config.JWT.Secret)
	if err != nil {
		return nil, errors.New("invalid refresh token")
	}

	// Get user
	user, err := s.userRepo.FindByID(claims.UserID)
	if err != nil {
		return nil, errors.New("user not found")
	}

	// Generate new tokens
	accessToken, err := jwt.GenerateToken(user.ID, user.Email, s.config.JWT.Secret, s.config.JWT.ExpiryHours)
	if err != nil {
		return nil, errors.New("failed to generate access token")
	}

	newRefreshToken, err := jwt.GenerateRefreshToken(user.ID, s.config.JWT.Secret, s.config.JWT.RefreshExpiryHours)
	if err != nil {
		return nil, errors.New("failed to generate refresh token")
	}

	return &LoginResult{
		User:         user,
		AccessToken:  accessToken,
		RefreshToken: newRefreshToken,
	}, nil
}

func (s *AuthService) GetUser(userID uuid.UUID) (*models.User, error) {
	user, err := s.userRepo.FindByID(userID)
	if err != nil {
		return nil, errors.New("user not found")
	}
	return user, nil
}

