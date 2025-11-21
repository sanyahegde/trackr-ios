package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// User represents a user in the system
type User struct {
	ID           uuid.UUID `gorm:"type:uuid;primaryKey;default:gen_random_uuid()" json:"id"`
	Email        string    `gorm:"uniqueIndex;not null" json:"email"`
	Name         string    `gorm:"not null" json:"name"`
	Username     string    `gorm:"uniqueIndex;not null" json:"username"`
	PasswordHash string    `gorm:"column:password_hash;not null" json:"-"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
	DeletedAt    gorm.DeletedAt `gorm:"index" json:"-"`

	// Relationships
	Goals              []Goal              `gorm:"foreignKey:UserID" json:"goals,omitempty"`
	CheckIns           []CheckIn           `gorm:"foreignKey:UserID" json:"check_ins,omitempty"`
	Streaks            []Streak            `gorm:"foreignKey:UserID" json:"streaks,omitempty"`
	Followers          []Friendship        `gorm:"foreignKey:FolloweeID" json:"followers,omitempty"`
	Following          []Friendship        `gorm:"foreignKey:FollowerID" json:"following,omitempty"`
	Challenges         []Challenge         `gorm:"foreignKey:CreatorID" json:"challenges,omitempty"`
	ChallengeParticipations []ChallengeParticipant `gorm:"foreignKey:UserID" json:"challenge_participations,omitempty"`
	Achievements       []Achievement       `gorm:"foreignKey:UserID" json:"achievements,omitempty"`
	ActivityFeed       []ActivityFeed      `gorm:"foreignKey:UserID" json:"activity_feed,omitempty"`
}

// Goal represents a user's goal
type Goal struct {
	ID          uuid.UUID `gorm:"type:uuid;primaryKey;default:gen_random_uuid()" json:"id"`
	UserID      uuid.UUID `gorm:"type:uuid;not null;index" json:"user_id"`
	Title       string    `gorm:"not null" json:"title"`
	Description string    `gorm:"type:text" json:"description"`
	Frequency   string    `gorm:"not null;default:'daily'" json:"frequency"` // daily, weekly, monthly, custom
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
	DeletedAt   gorm.DeletedAt `gorm:"index" json:"-"`

	// Relationships
	User     User      `gorm:"foreignKey:UserID" json:"user,omitempty"`
	CheckIns []CheckIn `gorm:"foreignKey:GoalID" json:"check_ins,omitempty"`
	Streak   *Streak   `gorm:"foreignKey:GoalID" json:"streak,omitempty"`
}

// CheckIn represents a check-in or progress update for a goal
type CheckIn struct {
	ID        uuid.UUID `gorm:"type:uuid;primaryKey;default:gen_random_uuid()" json:"id"`
	GoalID    uuid.UUID `gorm:"type:uuid;not null;index" json:"goal_id"`
	UserID    uuid.UUID `gorm:"type:uuid;not null;index" json:"user_id"`
	Note      string    `gorm:"type:text" json:"note,omitempty"`
	Value     *float64  `json:"value,omitempty"` // Optional numeric value (duration, count, etc.)
	Timestamp time.Time `gorm:"not null;default:CURRENT_TIMESTAMP" json:"timestamp"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`

	// Relationships
	Goal Goal `gorm:"foreignKey:GoalID" json:"goal,omitempty"`
	User User `gorm:"foreignKey:UserID" json:"user,omitempty"`
}

// Friendship represents a follow relationship between users
type Friendship struct {
	FollowerID uuid.UUID `gorm:"type:uuid;primaryKey" json:"follower_id"`
	FolloweeID uuid.UUID `gorm:"type:uuid;primaryKey" json:"followee_id"`
	CreatedAt  time.Time `json:"created_at"`

	// Relationships
	Follower User `gorm:"foreignKey:FollowerID" json:"follower,omitempty"`
	Followee User `gorm:"foreignKey:FolloweeID" json:"followee,omitempty"`
}

// ActivityFeed represents items in the activity feed
type ActivityFeed struct {
	ID          uuid.UUID `gorm:"type:uuid;primaryKey;default:gen_random_uuid()" json:"id"`
	UserID      uuid.UUID `gorm:"type:uuid;not null;index" json:"user_id"`
	Type        string    `gorm:"not null" json:"type"` // "checkin", "streak", "achievement"
	ReferenceID *uuid.UUID `gorm:"type:uuid" json:"reference_id,omitempty"` // checkin_id or achievement_id
	CreatedAt   time.Time `json:"created_at"`

	// Relationships
	User User `gorm:"foreignKey:UserID" json:"user,omitempty"`
}

// Streak represents streak information for a user's goal
type Streak struct {
	UserID          uuid.UUID `gorm:"type:uuid;primaryKey" json:"user_id"`
	GoalID          uuid.UUID `gorm:"type:uuid;primaryKey" json:"goal_id"`
	CurrentStreak   int       `gorm:"default:0" json:"current_streak"`
	LongestStreak   int       `gorm:"default:0" json:"longest_streak"`
	LastCheckInDate *time.Time `json:"last_checkin_date,omitempty"`
	UpdatedAt       time.Time `json:"updated_at"`

	// Relationships
	User User `gorm:"foreignKey:UserID" json:"user,omitempty"`
	Goal Goal `gorm:"foreignKey:GoalID" json:"goal,omitempty"`
}

// Challenge represents a challenge users can join
type Challenge struct {
	ID          uuid.UUID `gorm:"type:uuid;primaryKey;default:gen_random_uuid()" json:"id"`
	CreatorID   uuid.UUID `gorm:"type:uuid;not null;index" json:"creator_id"`
	Title       string    `gorm:"not null" json:"title"`
	Description string    `gorm:"type:text" json:"description"`
	DurationDays int      `gorm:"not null" json:"duration_days"`
	StartDate   time.Time `gorm:"not null" json:"start_date"`
	EndDate     time.Time `gorm:"not null" json:"end_date"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`

	// Relationships
	Creator      User                  `gorm:"foreignKey:CreatorID" json:"creator,omitempty"`
	Participants []ChallengeParticipant `gorm:"foreignKey:ChallengeID" json:"participants,omitempty"`
}

// ChallengeParticipant represents a user's participation in a challenge
type ChallengeParticipant struct {
	ID             uuid.UUID              `gorm:"type:uuid;primaryKey;default:gen_random_uuid()" json:"id"`
	ChallengeID    uuid.UUID              `gorm:"type:uuid;not null;index" json:"challenge_id"`
	UserID         uuid.UUID              `gorm:"type:uuid;not null;index" json:"user_id"`
	ProgressMetrics map[string]interface{} `gorm:"type:jsonb" json:"progress_metrics,omitempty"`
	JoinedAt       time.Time              `json:"joined_at"`

	// Relationships
	Challenge Challenge `gorm:"foreignKey:ChallengeID" json:"challenge,omitempty"`
	User      User      `gorm:"foreignKey:UserID" json:"user,omitempty"`
}

// Achievement represents an achievement earned by a user
type Achievement struct {
	ID          uuid.UUID `gorm:"type:uuid;primaryKey;default:gen_random_uuid()" json:"id"`
	UserID      uuid.UUID `gorm:"type:uuid;not null;index" json:"user_id"`
	Name        string    `gorm:"not null" json:"name"`
	Description string    `gorm:"type:text" json:"description"`
	Icon        string    `json:"icon,omitempty"`
	AchievedAt  time.Time `gorm:"not null" json:"achieved_at"`

	// Relationships
	User User `gorm:"foreignKey:UserID" json:"user,omitempty"`
}

// TableName overrides GORM's default table naming
func (User) TableName() string {
	return "users"
}

func (Goal) TableName() string {
	return "goals"
}

func (CheckIn) TableName() string {
	return "checkins"
}

func (Friendship) TableName() string {
	return "friendships"
}

func (ActivityFeed) TableName() string {
	return "activity_feed"
}

func (Streak) TableName() string {
	return "streaks"
}

func (Challenge) TableName() string {
	return "challenges"
}

func (ChallengeParticipant) TableName() string {
	return "challenge_participants"
}

func (Achievement) TableName() string {
	return "achievements"
}

// BeforeCreate hook to set UUID
func (u *User) BeforeCreate(tx *gorm.DB) error {
	if u.ID == uuid.Nil {
		u.ID = uuid.New()
	}
	return nil
}

func (g *Goal) BeforeCreate(tx *gorm.DB) error {
	if g.ID == uuid.Nil {
		g.ID = uuid.New()
	}
	return nil
}

func (c *CheckIn) BeforeCreate(tx *gorm.DB) error {
	if c.ID == uuid.Nil {
		c.ID = uuid.New()
	}
	return nil
}

func (a *ActivityFeed) BeforeCreate(tx *gorm.DB) error {
	if a.ID == uuid.Nil {
		a.ID = uuid.New()
	}
	return nil
}

func (ch *Challenge) BeforeCreate(tx *gorm.DB) error {
	if ch.ID == uuid.Nil {
		ch.ID = uuid.New()
	}
	return nil
}

func (cp *ChallengeParticipant) BeforeCreate(tx *gorm.DB) error {
	if cp.ID == uuid.Nil {
		cp.ID = uuid.New()
	}
	return nil
}

func (a *Achievement) BeforeCreate(tx *gorm.DB) error {
	if a.ID == uuid.Nil {
		a.ID = uuid.New()
	}
	return nil
}
