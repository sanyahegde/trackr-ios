package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/trackr/backend-go/internal/config"
	"github.com/trackr/backend-go/internal/database"
	"github.com/trackr/backend-go/internal/handlers"
	"github.com/trackr/backend-go/internal/middleware"
	"github.com/trackr/backend-go/internal/redis"
	"github.com/trackr/backend-go/internal/repository"
	"github.com/trackr/backend-go/internal/services"
)

func main() {
	// Load configuration
	cfg, err := config.Load()
	if err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}

	// Set Gin mode based on environment
	if cfg.Server.Env == "production" {
		gin.SetMode(gin.ReleaseMode)
	}

	// Connect to database
	if err := database.Connect(cfg); err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer database.Close()

	// Connect to Redis
	if err := redis.Connect(cfg); err != nil {
		log.Printf("Warning: Failed to connect to Redis: %v", err)
		log.Println("Continuing without Redis...")
	} else {
		defer redis.Close()
	}

	// Initialize repositories
	userRepo := repository.NewUserRepository()
	goalRepo := repository.NewGoalRepository()
	checkInRepo := repository.NewCheckInRepository()
	friendshipRepo := repository.NewFriendshipRepository()
	streakRepo := repository.NewStreakRepository()
	postRepo := repository.NewPostRepository()
	postLikeRepo := repository.NewPostLikeRepository()
	commentRepo := repository.NewCommentRepository()
	conversationRepo := repository.NewConversationRepository()
	messageRepo := repository.NewMessageRepository()

	// Initialize services
	authService := services.NewAuthService(userRepo, cfg)
	userService := services.NewUserService(userRepo, friendshipRepo)
	goalService := services.NewGoalService(goalRepo)
	streakService := services.NewStreakService(streakRepo, checkInRepo)
	checkInService := services.NewCheckInService(checkInRepo, goalRepo, streakService)
	postService := services.NewPostService(postRepo, postLikeRepo, commentRepo, friendshipRepo)
	messageService := services.NewMessageService(conversationRepo, messageRepo, friendshipRepo)

	// Initialize handlers
	authHandler := handlers.NewAuthHandler(authService)
	userHandler := handlers.NewUserHandler(userService)
	goalHandler := handlers.NewGoalHandler(goalService)
	checkInHandler := handlers.NewCheckInHandler(checkInService)
	streakHandler := handlers.NewStreakHandler(streakService)
	postHandler := handlers.NewPostHandler(postService)
	messageHandler := handlers.NewMessageHandler(messageService)
	healthHandler := handlers.NewHealthHandler()

	// Setup router
	router := gin.Default()

	// Middleware
	router.Use(middleware.CORSMiddleware(cfg))

	// Health check (no auth required)
	router.GET("/health", healthHandler.HealthCheck)

	// API routes
	api := router.Group("/api/v1")
	{
		// Auth routes (no auth required)
		auth := api.Group("/auth")
		{
			auth.POST("/signup", authHandler.Signup)
			auth.POST("/login", authHandler.Login)
			auth.POST("/refresh", authHandler.Refresh)
		}

		// Protected routes
		protected := api.Group("")
		protected.Use(middleware.AuthMiddleware(cfg))
		{
			// Auth
			protected.GET("/auth/me", authHandler.Me)

			// Users
			users := protected.Group("/users")
			{
				users.GET("/me", authHandler.Me)
				users.GET("/:id", userHandler.GetUser)
				users.GET("/:id/followers", userHandler.GetFollowers)
				users.GET("/:id/following", userHandler.GetFollowing)
				users.POST("/follow/:id", userHandler.Follow)
				users.DELETE("/follow/:id", userHandler.Unfollow)
				users.GET("/search", userHandler.Search)
			}

			// Goals
			goals := protected.Group("/goals")
			{
				goals.POST("", goalHandler.CreateGoal)
				goals.GET("", goalHandler.GetGoals)
				goals.GET("/:id", goalHandler.GetGoal)
				goals.PATCH("/:id", goalHandler.UpdateGoal)
				goals.DELETE("/:id", goalHandler.DeleteGoal)

				// Check-ins for goals
				goals.POST("/:id/checkins", checkInHandler.CreateCheckIn)
				goals.GET("/:id/checkins", checkInHandler.GetCheckIns)
			}

			// Feed (social media posts)
			protected.GET("/feed", postHandler.GetFeed)

			// Posts (social media)
			posts := protected.Group("/posts")
			{
				posts.POST("", postHandler.CreatePost)
				posts.GET("/:id", postHandler.GetPost)
				posts.DELETE("/:id", postHandler.DeletePost)
				posts.POST("/:id/like", postHandler.ToggleLike)
				posts.POST("/:id/comments", postHandler.CreateComment)
				posts.GET("/:id/comments", postHandler.GetComments)
			}

			// User posts
			protected.GET("/users/:id/posts", postHandler.GetUserPosts)

			// Check-ins feed (alternative to posts)
			protected.GET("/checkins/feed", checkInHandler.GetFeed)

			// Streaks
			streaks := protected.Group("/streaks")
			{
				streaks.GET("", streakHandler.GetStreaks)
				streaks.GET("/:goal_id", streakHandler.GetStreak)
			}

			// Messages
			messages := protected.Group("/messages")
			{
				messages.GET("/conversations", messageHandler.GetConversations)
				messages.POST("/conversations", messageHandler.CreateConversation)
				messages.GET("/conversations/:id", messageHandler.GetConversation)
				messages.GET("/conversations/:id/messages", messageHandler.GetMessages)
				messages.POST("/conversations/:id/messages", messageHandler.SendMessage)
				messages.POST("/conversations/:id/read", messageHandler.MarkAsRead)
				messages.DELETE("/messages/:id", messageHandler.DeleteMessage)
			}
		}
	}

	// Start server
	port := ":" + cfg.Server.Port
	log.Printf("🚀 Server starting on port %s", cfg.Server.Port)
	if err := router.Run(port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}


