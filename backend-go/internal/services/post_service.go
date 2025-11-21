package services

import (
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/trackr/backend-go/internal/models"
	"github.com/trackr/backend-go/internal/repository"
)

type PostService struct {
	postRepo       *repository.PostRepository
	postLikeRepo   *repository.PostLikeRepository
	commentRepo    *repository.CommentRepository
	friendshipRepo *repository.FriendshipRepository
}

func NewPostService(
	postRepo *repository.PostRepository,
	postLikeRepo *repository.PostLikeRepository,
	commentRepo *repository.CommentRepository,
	friendshipRepo *repository.FriendshipRepository,
) *PostService {
	return &PostService{
		postRepo:       postRepo,
		postLikeRepo:   postLikeRepo,
		commentRepo:    commentRepo,
		friendshipRepo: friendshipRepo,
	}
}

type CreatePostRequest struct {
	GoalID   *uuid.UUID
	Caption  string
	ImageURL string
}

func (s *PostService) CreatePost(userID uuid.UUID, req CreatePostRequest) (*models.Post, error) {
	post := &models.Post{
		UserID:     userID,
		GoalID:     req.GoalID,
		Caption:    req.Caption,
		ImageURL:   req.ImageURL,
		CreatedAt:  time.Now(),
		UpdatedAt:  time.Now(),
	}

	if err := s.postRepo.Create(post); err != nil {
		return nil, err
	}

	// Load relationships
	return s.postRepo.FindByID(post.ID)
}

func (s *PostService) GetPost(postID uuid.UUID) (*models.Post, error) {
	return s.postRepo.FindByID(postID)
}

func (s *PostService) GetUserPosts(userID uuid.UUID, limit int) ([]models.Post, error) {
	return s.postRepo.FindByUserID(userID, limit)
}

func (s *PostService) GetFeed(userID uuid.UUID, friendsOnly bool, limit int) ([]models.Post, error) {
	if friendsOnly {
		// Get following IDs
		following, err := s.friendshipRepo.GetFollowing(userID)
		if err != nil {
			return nil, err
		}
		
		userIDs := []uuid.UUID{userID} // Include own posts
		for _, user := range following {
			userIDs = append(userIDs, user.ID)
		}
		
		return s.postRepo.FindFeed(userIDs, limit)
	}
	
	// Global feed
	return s.postRepo.GetAll(limit)
}

func (s *PostService) ToggleLike(postID, userID uuid.UUID) (bool, error) {
	// Check if already liked
	exists, err := s.postLikeRepo.Exists(postID, userID)
	if err != nil {
		return false, err
	}

	if exists {
		// Unlike
		if err := s.postLikeRepo.Delete(postID, userID); err != nil {
			return false, err
		}
		
		// Decrement likes count
		post, err := s.postRepo.FindByID(postID)
		if err != nil {
			return false, err
		}
		post.LikesCount--
		s.postRepo.Update(post)
		
		return false, nil
	}

	// Like
	like := &models.PostLike{
		PostID: postID,
		UserID: userID,
	}
	if err := s.postLikeRepo.Create(like); err != nil {
		return false, err
	}

	// Increment likes count
	post, err := s.postRepo.FindByID(postID)
	if err != nil {
		return false, err
	}
	post.LikesCount++
	s.postRepo.Update(post)

	return true, nil
}

func (s *PostService) CreateComment(postID, userID uuid.UUID, text string) (*models.Comment, error) {
	comment := &models.Comment{
		PostID: postID,
		UserID: userID,
		Text:   text,
	}

	if err := s.commentRepo.Create(comment); err != nil {
		return nil, err
	}

	// Increment comments count
	post, err := s.postRepo.FindByID(postID)
	if err != nil {
		return nil, err
	}
	post.CommentsCount++
	s.postRepo.Update(post)

	// Load relationships
	return s.commentRepo.FindByID(comment.ID)
}

func (s *PostService) GetComments(postID uuid.UUID, limit int) ([]models.Comment, error) {
	return s.commentRepo.FindByPostID(postID, limit)
}

func (s *PostService) DeletePost(postID, userID uuid.UUID) error {
	post, err := s.postRepo.FindByID(postID)
	if err != nil {
		return err
	}

	if post.UserID != userID {
		return errors.New("permission denied: you can only delete your own posts")
	}

	return s.postRepo.Delete(postID)
}

