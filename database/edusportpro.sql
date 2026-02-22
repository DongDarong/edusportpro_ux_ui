-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 10, 2026 at 03:31 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `edusportpross`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `role_id` bigint(20) UNSIGNED DEFAULT NULL,
  `action` varchar(150) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `player_id` bigint(20) UNSIGNED NOT NULL,
  `match_id` bigint(20) UNSIGNED DEFAULT NULL,
  `training_id` bigint(20) UNSIGNED DEFAULT NULL,
  `attendance_status` enum('present','absent','late') NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `recorded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `coaches`
--

CREATE TABLE `coaches` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `specialization` varchar(100) DEFAULT NULL,
  `experience_years` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `coaches`
--

INSERT INTO `coaches` (`id`, `user_id`, `specialization`, `experience_years`, `created_at`) VALUES
(1, 2, 'Foot Ball', 4, '2026-01-10 21:23:56');

-- --------------------------------------------------------

--
-- Table structure for table `inventories`
--

CREATE TABLE `inventories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `item_name` varchar(150) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `condition_status` enum('good','damaged','lost') DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
  
  -- --------------------------------------------------------
  
  --
  -- Table structure for table `inventory_categories`
  --

  CREATE TABLE `inventory_categories` (
    `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` varchar(150) NOT NULL,
    `description` varchar(255) DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_inventory_categories_name` (`name`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

  --
  -- Dumping data for table `inventory_categories`
  --

  INSERT INTO `inventory_categories` (`name`, `description`) VALUES
  ('Equipment', 'Field gear and balls used across teams.'),
  ('Uniforms', 'Team jerseys and practice kits.'),
  ('Accessories', 'Small gear such as whistles, cones, and markers.'),
  ('Supplies', 'Consumables like first-aid and hydration supplies.');

  -- --------------------------------------------------------
  
  --
  -- Table structure for table `matches`
  --

CREATE TABLE `matches` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `home_team_id` bigint(20) UNSIGNED NOT NULL,
  `away_team_id` bigint(20) UNSIGNED NOT NULL,
  `match_date` date NOT NULL,
  `location` varchar(150) DEFAULT NULL,
  `status` enum('scheduled','completed','cancelled') DEFAULT 'scheduled',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Table structure for table `match_results`
--

CREATE TABLE `match_results` (
  `match_id` bigint(20) UNSIGNED NOT NULL,
  `home_goals` int(11) DEFAULT 0,
  `away_goals` int(11) DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(150) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `otp_verifications`
--

CREATE TABLE `otp_verifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `otp_code` varchar(10) NOT NULL,
  `purpose` enum('password_reset','email_verification','login') NOT NULL,
  `expires_at` datetime NOT NULL,
  `is_used` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `performance_records`
--

CREATE TABLE `performance_records` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `player_id` bigint(20) UNSIGNED NOT NULL,
  `match_id` bigint(20) UNSIGNED DEFAULT NULL,
  `rating` decimal(3,1) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `module` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `module`, `description`, `created_at`) VALUES
(1, 'user_view', 'users', 'View user list and details', '2026-01-10 13:03:11'),
(2, 'user_create', 'users', 'Create new users', '2026-01-10 13:03:11'),
(3, 'user_update', 'users', 'Update user information', '2026-01-10 13:03:11'),
(4, 'user_delete', 'users', 'Delete users', '2026-01-10 13:03:11'),
(5, 'role_view', 'roles', 'View roles', '2026-01-10 13:03:11'),
(6, 'role_manage', 'roles', 'Create and update roles', '2026-01-10 13:03:11'),
(7, 'permission_manage', 'permissions', 'Assign permissions to roles', '2026-01-10 13:03:11'),
(8, 'player_view', 'players', 'View player profiles', '2026-01-10 13:03:11'),
(9, 'player_create', 'players', 'Register new players', '2026-01-10 13:03:11'),
(10, 'player_update', 'players', 'Update player information', '2026-01-10 13:03:11'),
(11, 'player_delete', 'players', 'Remove players', '2026-01-10 13:03:11'),
(12, 'coach_view', 'coaches', 'View coaches', '2026-01-10 13:03:11'),
(13, 'coach_create', 'coaches', 'Add new coach', '2026-01-10 13:03:11'),
(14, 'coach_update', 'coaches', 'Update coach details', '2026-01-10 13:03:11'),
(15, 'coach_delete', 'coaches', 'Remove coach', '2026-01-10 13:03:11'),
(16, 'team_view', 'teams', 'View teams', '2026-01-10 13:03:11'),
(17, 'team_create', 'teams', 'Create new teams', '2026-01-10 13:03:11'),
(18, 'team_update', 'teams', 'Update team information', '2026-01-10 13:03:11'),
(19, 'team_delete', 'teams', 'Delete teams', '2026-01-10 13:03:11'),
(20, 'team_assign_players', 'teams', 'Assign players to teams', '2026-01-10 13:03:11'),
(21, 'match_view', 'matches', 'View match schedules and results', '2026-01-10 13:03:11'),
(22, 'match_create', 'matches', 'Create match schedules', '2026-01-10 13:03:11'),
(23, 'match_update', 'matches', 'Update match results', '2026-01-10 13:03:11'),
(24, 'match_delete', 'matches', 'Delete matches', '2026-01-10 13:03:11'),
(25, 'training_view', 'trainings', 'View training schedules', '2026-01-10 13:03:11'),
(26, 'training_create', 'trainings', 'Create training sessions', '2026-01-10 13:03:11'),
(27, 'training_update', 'trainings', 'Update training sessions', '2026-01-10 13:03:11'),
(28, 'training_delete', 'trainings', 'Delete training sessions', '2026-01-10 13:03:11'),
(29, 'attendance_view', 'attendance', 'View attendance records', '2026-01-10 13:03:11'),
(30, 'attendance_manage', 'attendance', 'Mark and update attendance', '2026-01-10 13:03:11'),
(31, 'performance_view', 'performance', 'View performance records', '2026-01-10 13:03:11'),
(32, 'performance_record', 'performance', 'Record player performance', '2026-01-10 13:03:11'),
(33, 'inventory_view', 'inventories', 'View inventory items', '2026-01-10 13:03:11'),
(34, 'inventory_manage', 'inventories', 'Add, update, and remove inventory', '2026-01-10 13:03:11'),
(35, 'notification_view', 'notifications', 'View notifications', '2026-01-10 13:03:11'),
(36, 'notification_send', 'notifications', 'Send notifications', '2026-01-10 13:03:11'),
(37, 'activity_view', 'activity_logs', 'View system activity logs', '2026-01-10 13:03:11');

-- Extra permissions for tournament/division/calendar access control
INSERT INTO `permissions` (`id`, `name`, `module`, `description`, `created_at`) VALUES
(38, 'tournament_view', 'tournaments', 'View tournament information', '2026-01-11 09:03:11'),
(39, 'tournament_manage', 'tournaments', 'Create, update, and delete tournaments', '2026-01-11 09:03:11'),
(40, 'division_view', 'divisions', 'View division data and standings', '2026-01-11 09:03:11'),
(41, 'division_manage', 'divisions', 'Create, update, and delete divisions', '2026-01-11 09:03:11'),
(42, 'calendar_view', 'calendar_events', 'View calendar events', '2026-01-11 09:03:11'),
(43, 'calendar_manage', 'calendar_events', 'Create, update, and delete calendar events', '2026-01-11 09:03:11');

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `profile_image` varchar(1024) NOT NULL,
  `gender` enum('male','female') DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `nationality` varchar(50) DEFAULT NULL,
  `ethnicity` varchar(50) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`id`, `user_id`, `first_name`, `last_name`, `profile_image`, `gender`, `date_of_birth`, `nationality`, `ethnicity`, `status`, `created_at`, `updated_at`) VALUES
(1, 3, 'Dong', 'Darong', '', 'male', '2000-01-14', 'KHMER', 'KHMER', 'active', '2026-01-10 14:22:38', '2026-01-10 21:22:38');

-- --------------------------------------------------------

--
-- Table structure for table `player_addresses`
--

CREATE TABLE `player_addresses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `player_id` bigint(20) UNSIGNED NOT NULL,
  `village` varchar(100) DEFAULT NULL,
  `commune` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_guardians`
--

CREATE TABLE `player_guardians` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `player_id` bigint(20) UNSIGNED NOT NULL,
  `father_name` varchar(100) DEFAULT NULL,
  `father_age` int(11) DEFAULT NULL,
  `father_occupation` varchar(100) DEFAULT NULL,
  `mother_name` varchar(100) DEFAULT NULL,
  `mother_age` int(11) DEFAULT NULL,
  `mother_occupation` varchar(100) DEFAULT NULL,
  `guardian_phone` varchar(20) DEFAULT NULL,
  `relationship` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_physical_attributes`
--

CREATE TABLE `player_physical_attributes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `player_id` bigint(20) UNSIGNED NOT NULL,
  `height_cm` int(11) DEFAULT NULL,
  `weight_kg` int(11) DEFAULT NULL,
  `preferred_foot` enum('left','right') DEFAULT NULL,
  `blood_type` varchar(5) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_positions`
--

CREATE TABLE `player_positions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `player_id` bigint(20) UNSIGNED NOT NULL,
  `primary_position` varchar(50) DEFAULT NULL,
  `secondary_position` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_schools`
--

CREATE TABLE `player_schools` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `player_id` bigint(20) UNSIGNED NOT NULL,
  `school_name` varchar(150) DEFAULT NULL,
  `grade` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
  
  -- --------------------------------------------------------
  --
  -- Table structure for table `attendance_records`
  --

  CREATE TABLE `attendance_records` (
    `id` varchar(32) NOT NULL,
    `subject_type` enum('player','coach') NOT NULL,
    `subject_id` varchar(32) NOT NULL,
    `team_id` varchar(32) DEFAULT NULL,
    `coach_id` varchar(32) DEFAULT NULL,
    `date` date NOT NULL,
    `activity_type` enum('training','match','other') NOT NULL DEFAULT 'training',
    `status` enum('present','absent','late','excused') NOT NULL DEFAULT 'present',
    `note` varchar(255) DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

  --
  -- Dumping data for table `attendance_records`
  --

  INSERT INTO `attendance_records` (`id`, `subject_type`, `subject_id`, `team_id`, `coach_id`, `date`, `activity_type`, `status`, `note`) VALUES
  ('AR-001', 'player', 'PL-001', 'T001', 'C001', '2026-02-18', 'training', 'present', ''),
  ('AR-002', 'player', 'PL-002', 'T002', 'C004', '2026-02-18', 'training', 'absent', 'Sick'),
  ('AR-003', 'player', 'PL-003', 'T003', 'C002', '2026-02-18', 'training', 'late', 'Traffic'),
  ('AR-004', 'coach', 'C001', 'T001', '', '2026-02-18', 'training', 'present', ''),
  ('AR-005', 'coach', 'C002', 'T003', '', '2026-02-18', 'training', 'excused', 'Approved Leave'),
  ('AR-006', 'coach', 'C004', 'T002', '', '2026-02-18', 'match', 'late', 'Traffic');

  -- --------------------------------------------------------

  --
  -- Table structure for table `roles`
  --
  
CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `created_at`) VALUES
(1, 'admin', 'System administrator with full access', '2026-01-10 13:01:11'),
(2, 'coach', 'Coach responsible for teams, training, and attendance', '2026-01-10 13:01:11'),
(3, 'player', 'Player with access to personal profile and performance', '2026-01-10 13:01:11');

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `permission_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_permissions`
--

INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(1, 16),
(1, 17),
(1, 18),
(1, 19),
(1, 20),
(1, 21),
(1, 22),
(1, 23),
(1, 24),
(1, 25),
(1, 26),
(1, 27),
(1, 28),
(1, 29),
(1, 30),
(1, 31),
(1, 32),
(1, 33),
(1, 34),
(1, 35),
(1, 36),
(1, 37),
(2, 8),
(2, 10),
(2, 16),
(2, 20),
(2, 21),
(2, 22),
(2, 23),
(2, 25),
(2, 26),
(2, 27),
(2, 29),
(2, 30),
(2, 31),
(2, 32),
(2, 35),
(2, 36),
(3, 8),
(3, 21),
(3, 25),
(3, 29),
(3, 31),
(3, 35);

-- Role access for tournament/division/calendar:
-- admin = full, coach = tournament/division view-only + calendar manage, player = view-only
INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(1, 38),
(1, 39),
(1, 40),
(1, 41),
(1, 42),
(1, 43),
(2, 38),
(2, 40),
(2, 42),
(2, 43),
(3, 38),
(3, 40),
(3, 42);

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE `teams` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `logo_image` varchar(1024) NOT NULL,
  `division` varchar(50) DEFAULT NULL,
  `status` enum('active','training','inactive') DEFAULT 'active',
  `team_role` enum('home_team','away_team') DEFAULT NULL,
  `coach_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `team_players`
--

CREATE TABLE `team_players` (
  `team_id` bigint(20) UNSIGNED NOT NULL,
  `player_id` bigint(20) UNSIGNED NOT NULL,
  `joined_at` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trainings`
--

CREATE TABLE `trainings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `team_id` bigint(20) UNSIGNED NOT NULL,
  `training_date` date DEFAULT NULL,
  `topic` varchar(150) DEFAULT NULL,
  `location` varchar(150) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `role_id`, `name`, `email`, `password`, `phone`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 'System Admin', 'admin@edusportpro.com', 'admin123456', '012000001', 'active', '2026-01-10 13:11:05', '2026-01-10 14:19:43'),
(2, 2, 'Coach Sok Dara', 'coach@edusportpro.com', 'coach123456', '012000002', 'active', '2026-01-10 13:11:05', '2026-01-10 14:19:38'),
(3, 3, 'Player Vannak', 'player@edusportpro.com', 'player123456', '012000003', 'active', '2026-01-10 13:11:05', '2026-01-10 14:19:32');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `role_id` (`role_id`);

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `match_id` (`match_id`),
  ADD KEY `training_id` (`training_id`);

--
-- Indexes for table `coaches`
--
ALTER TABLE `coaches`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `inventories`
--
ALTER TABLE `inventories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `matches`
--
ALTER TABLE `matches`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_matches_home_team` (`home_team_id`),
  ADD KEY `fk_matches_away_team` (`away_team_id`);

--
-- Indexes for table `match_results`
--
ALTER TABLE `match_results`
  ADD PRIMARY KEY (`match_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `otp_verifications`
--
ALTER TABLE `otp_verifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `performance_records`
--
ALTER TABLE `performance_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `match_id` (`match_id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `player_addresses`
--
ALTER TABLE `player_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `player_guardians`
--
ALTER TABLE `player_guardians`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `player_physical_attributes`
--
ALTER TABLE `player_physical_attributes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `player_positions`
--
ALTER TABLE `player_positions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `player_schools`
--
ALTER TABLE `player_schools`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`role_id`,`permission_id`),
  ADD KEY `permission_id` (`permission_id`);

--
-- Indexes for table `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`id`),
  ADD KEY `coach_id` (`coach_id`);

--
-- Indexes for table `team_players`
--
ALTER TABLE `team_players`
  ADD PRIMARY KEY (`team_id`,`player_id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `trainings`
--
ALTER TABLE `trainings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `team_id` (`team_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `coaches`
--
ALTER TABLE `coaches`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `inventories`
--
ALTER TABLE `inventories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `matches`
--
ALTER TABLE `matches`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `otp_verifications`
--
ALTER TABLE `otp_verifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `performance_records`
--
ALTER TABLE `performance_records`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `player_addresses`
--
ALTER TABLE `player_addresses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_guardians`
--
ALTER TABLE `player_guardians`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_physical_attributes`
--
ALTER TABLE `player_physical_attributes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_positions`
--
ALTER TABLE `player_positions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_schools`
--
ALTER TABLE `player_schools`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `teams`
--
ALTER TABLE `teams`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trainings`
--
ALTER TABLE `trainings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `activity_logs_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attendance_ibfk_2` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attendance_ibfk_3` FOREIGN KEY (`training_id`) REFERENCES `trainings` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `coaches`
--
ALTER TABLE `coaches`
  ADD CONSTRAINT `coaches_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `matches`
--
ALTER TABLE `matches`
  ADD CONSTRAINT `fk_matches_away_team` FOREIGN KEY (`away_team_id`) REFERENCES `teams` (`id`),
  ADD CONSTRAINT `fk_matches_home_team` FOREIGN KEY (`home_team_id`) REFERENCES `teams` (`id`);

--
-- Constraints for table `match_results`
--
ALTER TABLE `match_results`
  ADD CONSTRAINT `match_results_ibfk_1` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `otp_verifications`
--
ALTER TABLE `otp_verifications`
  ADD CONSTRAINT `otp_verifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `performance_records`
--
ALTER TABLE `performance_records`
  ADD CONSTRAINT `performance_records_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`),
  ADD CONSTRAINT `performance_records_ibfk_2` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`);

--
-- Constraints for table `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `player_addresses`
--
ALTER TABLE `player_addresses`
  ADD CONSTRAINT `player_addresses_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_guardians`
--
ALTER TABLE `player_guardians`
  ADD CONSTRAINT `player_guardians_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_physical_attributes`
--
ALTER TABLE `player_physical_attributes`
  ADD CONSTRAINT `player_physical_attributes_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_positions`
--
ALTER TABLE `player_positions`
  ADD CONSTRAINT `player_positions_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_schools`
--
ALTER TABLE `player_schools`
  ADD CONSTRAINT `player_schools_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `teams`
--
ALTER TABLE `teams`
  ADD CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`coach_id`) REFERENCES `coaches` (`id`);

--
-- Constraints for table `team_players`
--
ALTER TABLE `team_players`
  ADD CONSTRAINT `team_players_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `team_players_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `trainings`
--
ALTER TABLE `trainings`
  ADD CONSTRAINT `trainings_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

-- --------------------------------------------------------
--
-- Tournament System Extension
--

-- TOURNAMENTS
CREATE TABLE `tournaments` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `tournament_type` enum('league','knockout','friendly_cup') NOT NULL DEFAULT 'league',
  `season_year` int(11) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('planned','ongoing','completed','cancelled') NOT NULL DEFAULT 'planned',
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_tournament_season_year` (`season_year`),
  KEY `idx_tournament_status` (`status`),
  KEY `idx_tournament_created_by` (`created_by`),
  CONSTRAINT `tournaments_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DIVISIONS (U12 U14 U16...)
CREATE TABLE `divisions` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `min_age` int(11) DEFAULT NULL,
  `max_age` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TEAM DIVISIONS (season based)
CREATE TABLE `team_divisions` (
  `team_id` bigint(20) UNSIGNED NOT NULL,
  `division_id` bigint(20) UNSIGNED NOT NULL,
  `season_year` int(11) NOT NULL,
  PRIMARY KEY (`team_id`,`division_id`,`season_year`),
  KEY `division_id` (`division_id`),
  CONSTRAINT `team_divisions_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `team_divisions_ibfk_2` FOREIGN KEY (`division_id`) REFERENCES `divisions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- GROUPS
CREATE TABLE `groups` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `division_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(10) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `division_id` (`division_id`),
  CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`division_id`) REFERENCES `divisions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- GROUP TEAMS
CREATE TABLE `group_teams` (
  `group_id` bigint(20) UNSIGNED NOT NULL,
  `team_id` bigint(20) UNSIGNED NOT NULL,
  PRIMARY KEY (`group_id`,`team_id`),
  KEY `team_id` (`team_id`),
  CONSTRAINT `group_teams_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `group_teams_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- EXTEND MATCHES
ALTER TABLE `matches`
  ADD COLUMN `tournament_id` bigint(20) UNSIGNED DEFAULT NULL,
  ADD COLUMN `division_id` bigint(20) UNSIGNED DEFAULT NULL,
  ADD COLUMN `group_id` bigint(20) UNSIGNED DEFAULT NULL,
  ADD COLUMN `stage` enum('group','quarter','semi','final') DEFAULT 'group',
  ADD KEY `tournament_id` (`tournament_id`),
  ADD KEY `division_id` (`division_id`),
  ADD KEY `group_id` (`group_id`),
  ADD CONSTRAINT `matches_ibfk_tournament` FOREIGN KEY (`tournament_id`) REFERENCES `tournaments` (`id`),
  ADD CONSTRAINT `matches_ibfk_division` FOREIGN KEY (`division_id`) REFERENCES `divisions` (`id`),
  ADD CONSTRAINT `matches_ibfk_group` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`);

-- MATCH EVENTS (live timeline)
CREATE TABLE `match_events` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `match_id` bigint(20) UNSIGNED NOT NULL,
  `team_id` bigint(20) UNSIGNED NOT NULL,
  `player_id` bigint(20) UNSIGNED NOT NULL,
  `minute` int(11) DEFAULT NULL,
  `event_type` enum('goal','assist','yellow','red','sub_in','sub_out') DEFAULT NULL,
  `related_player_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `match_id` (`match_id`),
  KEY `team_id` (`team_id`),
  KEY `player_id` (`player_id`),
  CONSTRAINT `match_events_ibfk_1` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `match_events_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`),
  CONSTRAINT `match_events_ibfk_3` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`),
  CONSTRAINT `match_events_ibfk_4` FOREIGN KEY (`related_player_id`) REFERENCES `players` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- STANDINGS TABLE
CREATE TABLE `standings` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_id` bigint(20) UNSIGNED NOT NULL,
  `team_id` bigint(20) UNSIGNED NOT NULL,
  `played` int(11) DEFAULT 0,
  `win` int(11) DEFAULT 0,
  `draw` int(11) DEFAULT 0,
  `lose` int(11) DEFAULT 0,
  `goals_for` int(11) DEFAULT 0,
  `goals_against` int(11) DEFAULT 0,
  `goal_diff` int(11) DEFAULT 0,
  `points` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_team_unique` (`group_id`,`team_id`),
  KEY `team_id` (`team_id`),
  CONSTRAINT `standings_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `standings_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- PLAYER MATCH STATISTICS
CREATE TABLE `player_match_statistics` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `match_id` bigint(20) UNSIGNED NOT NULL,
  `player_id` bigint(20) UNSIGNED NOT NULL,
  `goals` int(11) DEFAULT 0,
  `assists` int(11) DEFAULT 0,
  `yellow_cards` int(11) DEFAULT 0,
  `red_cards` int(11) DEFAULT 0,
  `minutes_played` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `match_player_unique` (`match_id`,`player_id`),
  KEY `player_id` (`player_id`),
  CONSTRAINT `player_match_statistics_ibfk_1` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `player_match_statistics_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Seed Data: Tournament System
--

-- Teams
INSERT INTO `teams` (`id`, `name`, `logo_image`, `division`, `status`, `team_role`, `coach_id`, `created_at`, `updated_at`) VALUES
(1, 'Hope U12 A', '', 'U12', 'active', NULL, 1, '2026-01-11 08:00:00', '2026-01-11 08:00:00'),
(2, 'Hope U12 B', '', 'U12', 'active', NULL, 1, '2026-01-11 08:00:00', '2026-01-11 08:00:00'),
(3, 'Hope U14 A', '', 'U14', 'active', NULL, 1, '2026-01-11 08:00:00', '2026-01-11 08:00:00'),
(4, 'Hope U14 B', '', 'U14', 'training', NULL, 1, '2026-01-11 08:00:00', '2026-01-11 08:00:00'),
(5, 'Hope U16 A', '', 'U16', 'active', NULL, 1, '2026-01-11 08:00:00', '2026-01-11 08:00:00'),
(6, 'Hope U16 B', '', 'U16', 'active', NULL, 1, '2026-01-11 08:00:00', '2026-01-11 08:00:00');

-- Extra players for match events/statistics
INSERT INTO `players` (`id`, `user_id`, `first_name`, `last_name`, `profile_image`, `gender`, `date_of_birth`, `nationality`, `ethnicity`, `status`, `created_at`, `updated_at`) VALUES
(2, NULL, 'Sok', 'Dara', '', 'male', '2012-03-11', 'KHMER', 'KHMER', 'active', '2026-01-11 09:00:00', '2026-01-11 09:00:00'),
(3, NULL, 'Chan', 'Vanna', '', 'male', '2011-07-20', 'KHMER', 'KHMER', 'active', '2026-01-11 09:00:00', '2026-01-11 09:00:00'),
(4, NULL, 'Neth', 'Sopheak', '', 'male', '2010-12-02', 'KHMER', 'KHMER', 'active', '2026-01-11 09:00:00', '2026-01-11 09:00:00'),
(5, NULL, 'Kim', 'Savuth', '', 'male', '2011-01-15', 'KHMER', 'KHMER', 'active', '2026-01-11 09:00:00', '2026-01-11 09:00:00'),
(6, NULL, 'Rath', 'Piseth', '', 'male', '2010-06-01', 'KHMER', 'KHMER', 'active', '2026-01-11 09:00:00', '2026-01-11 09:00:00');

-- Divisions
INSERT INTO `divisions` (`id`, `name`, `min_age`, `max_age`, `created_at`) VALUES
(1, 'U12', 10, 12, '2026-01-11 10:00:00'),
(2, 'U14', 13, 14, '2026-01-11 10:00:00'),
(3, 'U16', 15, 16, '2026-01-11 10:00:00');

-- Tournaments
INSERT INTO `tournaments` (`id`, `name`, `tournament_type`, `season_year`, `start_date`, `end_date`, `status`, `created_by`) VALUES
(1, 'Hope Youth League 2026', 'league', 2026, '2026-01-15', '2026-04-30', 'ongoing', 1),
(2, 'Hope Development Cup', 'knockout', 2026, '2026-05-10', '2026-06-20', 'planned', 1),
(3, 'Junior Friendship Series', 'friendly_cup', 2026, '2026-08-01', '2026-08-31', 'planned', 1);

-- Tournament divisions mapping
INSERT INTO `tournament_divisions` (`tournament_id`, `division_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2),
(3, 1);

-- Team division mapping by season
INSERT INTO `team_divisions` (`team_id`, `division_id`, `season_year`) VALUES
(1, 1, 2026),
(2, 1, 2026),
(3, 2, 2026),
(4, 2, 2026),
(5, 3, 2026),
(6, 3, 2026);

-- Groups
INSERT INTO `groups` (`id`, `division_id`, `name`, `created_at`) VALUES
(1, 1, 'A', '2026-01-12 08:00:00'),
(2, 2, 'B', '2026-01-12 08:00:00'),
(3, 3, 'C', '2026-01-12 08:00:00');

-- Group teams
INSERT INTO `group_teams` (`group_id`, `team_id`) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6);

-- Matches with division/group/stage
INSERT INTO `matches` (`id`, `home_team_id`, `away_team_id`, `match_date`, `location`, `status`, `created_at`, `tournament_id`, `division_id`, `group_id`, `stage`) VALUES
(1, 1, 2, '2026-03-10', 'Field 1', 'completed', '2026-03-10 08:00:00', 1, 1, 1, 'group'),
(2, 3, 4, '2026-03-11', 'Field 2', 'scheduled', '2026-03-11 08:00:00', 1, 2, 2, 'group'),
(3, 5, 6, '2026-03-12', 'Main Stadium', 'scheduled', '2026-03-12 08:00:00', 1, 3, 3, 'group'),
(4, 1, 3, '2026-04-01', 'Main Stadium', 'scheduled', '2026-03-20 08:00:00', 1, 1, NULL, 'quarter'),
(5, 5, 2, '2026-04-10', 'Main Stadium', 'scheduled', '2026-03-20 08:00:00', 2, 3, NULL, 'semi'),
(6, 1, 5, '2026-04-20', 'Main Stadium', 'scheduled', '2026-03-20 08:00:00', 2, 3, NULL, 'final');

-- Match results (completed match)
INSERT INTO `match_results` (`match_id`, `home_goals`, `away_goals`, `created_at`) VALUES
(1, 2, 1, '2026-03-10 10:00:00');

-- Match timeline events
INSERT INTO `match_events` (`id`, `match_id`, `team_id`, `player_id`, `minute`, `event_type`, `related_player_id`, `created_at`) VALUES
(1, 1, 1, 2, 12, 'goal', 3, '2026-03-10 08:20:00'),
(2, 1, 2, 4, 39, 'yellow', NULL, '2026-03-10 08:47:00'),
(3, 1, 2, 5, 58, 'goal', 6, '2026-03-10 09:06:00'),
(4, 1, 1, 1, 70, 'goal', 2, '2026-03-10 09:18:00');

-- Standings
INSERT INTO `standings` (`id`, `group_id`, `team_id`, `played`, `win`, `draw`, `lose`, `goals_for`, `goals_against`, `goal_diff`, `points`) VALUES
(1, 1, 1, 1, 1, 0, 0, 2, 1, 1, 3),
(2, 1, 2, 1, 0, 0, 1, 1, 2, -1, 0),
(3, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 2, 4, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 3, 5, 0, 0, 0, 0, 0, 0, 0, 0),
(6, 3, 6, 0, 0, 0, 0, 0, 0, 0, 0);

-- Player match statistics
INSERT INTO `player_match_statistics` (`id`, `match_id`, `player_id`, `goals`, `assists`, `yellow_cards`, `red_cards`, `minutes_played`) VALUES
(1, 1, 1, 1, 0, 0, 0, 90),
(2, 1, 2, 1, 1, 0, 0, 90),
(3, 1, 3, 0, 1, 0, 0, 82),
(4, 1, 4, 0, 0, 1, 0, 90),
(5, 1, 5, 1, 0, 0, 0, 90),
(6, 1, 6, 0, 1, 0, 0, 75);

-- --------------------------------------------------------
--
-- Calendar Events Extension
--

CREATE TABLE `calendar_events` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `event_type` enum('match','training','meeting','other') NOT NULL DEFAULT 'match',
  `comment` varchar(255) DEFAULT NULL,
  `event_date` date NOT NULL,
  `event_time` time DEFAULT NULL,
  `team_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_calendar_event_date` (`event_date`),
  KEY `idx_calendar_team_id` (`team_id`),
  KEY `idx_calendar_created_by` (`created_by`),
  CONSTRAINT `calendar_events_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE SET NULL,
  CONSTRAINT `calendar_events_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TOURNAMENT DIVISIONS
  CREATE TABLE `tournament_divisions` (
    `tournament_id` bigint(20) UNSIGNED NOT NULL,
    `division_id` bigint(20) UNSIGNED NOT NULL,
    PRIMARY KEY (`tournament_id`,`division_id`),
    KEY `idx_tournament_divisions_division` (`division_id`),
    CONSTRAINT `tournament_divisions_ibfk_1` FOREIGN KEY (`tournament_id`) REFERENCES `tournaments` (`id`) ON DELETE CASCADE,
    CONSTRAINT `tournament_divisions_ibfk_2` FOREIGN KEY (`division_id`) REFERENCES `divisions` (`id`) ON DELETE CASCADE
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

  -- --------------------------------------------------------
  --
  -- Table structure for table `tournament_team_map`
  --

  CREATE TABLE `tournament_team_map` (
    `tournament_code` varchar(32) NOT NULL,
    `team_code` varchar(32) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`tournament_code`, `team_code`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

  --
  -- Dumping data for table `tournament_team_map`
  --

  INSERT INTO `tournament_team_map` (`tournament_code`, `team_code`) VALUES
  ('TRN-2026-001', 'T001'),
  ('TRN-2026-001', 'T002'),
  ('TRN-2026-001', 'T003'),
  ('TRN-2026-002', 'T004'),
  ('TRN-2026-002', 'T005'),
  ('TRN-2026-003', 'T006'),
  ('TRN-2026-003', 'T007'),
  ('TRN-2026-003', 'T008');
  
  INSERT INTO `calendar_events` (`title`, `event_type`, `comment`, `event_date`, `event_time`, `team_id`, `created_by`) VALUES
('Training', 'training', NULL, '2026-12-05', '10:00:00', 1, 1),
('Tactics Meeting', 'meeting', NULL, '2026-12-08', '14:00:00', NULL, 1),
('vs Team C', 'match', NULL, '2026-12-20', '16:00:00', 1, 1),
('Fitness Test', 'other', 'Pre-season endurance check', '2026-12-15', '09:00:00', 3, 1);

-- --------------------------------------------------------
--
-- API-Ready Views (for UI data binding)
--

CREATE OR REPLACE VIEW `vw_tournament_summary` AS
SELECT
  t.id,
  t.name,
  t.tournament_type,
  t.season_year,
  t.start_date,
  t.end_date,
  t.status,
  COUNT(DISTINCT td.division_id) AS division_count,
  COUNT(DISTINCT m.id) AS match_count
FROM tournaments t
LEFT JOIN tournament_divisions td ON td.tournament_id = t.id
LEFT JOIN matches m ON m.tournament_id = t.id
GROUP BY t.id, t.name, t.tournament_type, t.season_year, t.start_date, t.end_date, t.status;

CREATE OR REPLACE VIEW `vw_division_standings` AS
SELECT
  d.id AS division_id,
  d.name AS division_name,
  g.id AS group_id,
  g.name AS group_name,
  s.team_id,
  tm.name AS team_name,
  s.played,
  s.win,
  s.draw,
  s.lose,
  s.goals_for,
  s.goals_against,
  s.goal_diff,
  s.points
FROM standings s
JOIN groups g ON g.id = s.group_id
JOIN divisions d ON d.id = g.division_id
JOIN teams tm ON tm.id = s.team_id;

CREATE OR REPLACE VIEW `vw_calendar_events` AS
SELECT
  ce.id,
  ce.title,
  ce.event_type,
  ce.comment,
  ce.event_date,
  ce.event_time,
  ce.team_id,
  COALESCE(t.name, 'All Teams') AS team_name,
  ce.created_by,
  u.name AS created_by_name,
  ce.created_at,
  ce.updated_at
FROM calendar_events ce
LEFT JOIN teams t ON t.id = ce.team_id
LEFT JOIN users u ON u.id = ce.created_by;

-- --------------------------------------------------------
--
-- Notification Delivery Extension (Calendar Events)
--

-- Link notification back to event for traceability
ALTER TABLE `notifications`
  ADD COLUMN `event_id` bigint(20) UNSIGNED DEFAULT NULL AFTER `user_id`,
  ADD KEY `idx_notifications_event_id` (`event_id`),
  ADD CONSTRAINT `notifications_ibfk_event` FOREIGN KEY (`event_id`) REFERENCES `calendar_events` (`id`) ON DELETE CASCADE;

-- Stores exact delivery audience for each event
CREATE TABLE `calendar_event_recipients` (
  `event_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`event_id`,`user_id`),
  KEY `idx_calendar_event_recipients_user_id` (`user_id`),
  CONSTRAINT `calendar_event_recipients_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `calendar_events` (`id`) ON DELETE CASCADE,
  CONSTRAINT `calendar_event_recipients_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Supports one or many teams per event
CREATE TABLE `calendar_event_teams` (
  `event_id` bigint(20) UNSIGNED NOT NULL,
  `team_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`event_id`,`team_id`),
  KEY `idx_calendar_event_teams_team_id` (`team_id`),
  CONSTRAINT `calendar_event_teams_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `calendar_events` (`id`) ON DELETE CASCADE,
  CONSTRAINT `calendar_event_teams_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DELIMITER $$
DROP PROCEDURE IF EXISTS `sp_create_calendar_event` $$
CREATE PROCEDURE `sp_create_calendar_event` (
  IN p_creator_user_id BIGINT UNSIGNED,
  IN p_title VARCHAR(150),
  IN p_event_type ENUM('match','training','meeting','other'),
  IN p_comment VARCHAR(255),
  IN p_event_date DATE,
  IN p_event_time TIME,
  IN p_is_all_teams TINYINT(1),
  IN p_team_ids_csv TEXT
)
BEGIN
  DECLARE v_role_name VARCHAR(50);
  DECLARE v_creator_coach_id BIGINT UNSIGNED;
  DECLARE v_creator_team_id BIGINT UNSIGNED;
  DECLARE v_event_id BIGINT UNSIGNED;
  DECLARE v_message TEXT;
  DECLARE v_first_team_id BIGINT UNSIGNED DEFAULT NULL;
  DECLARE v_csv TEXT;
  DECLARE v_token VARCHAR(32);
  DECLARE v_target_count INT DEFAULT 0;

  SELECT r.name
    INTO v_role_name
  FROM users u
  JOIN roles r ON r.id = u.role_id
  WHERE u.id = p_creator_user_id
  LIMIT 1;

  IF v_role_name IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid creator user id';
  END IF;

  -- Player is view-only for calendar events
  IF v_role_name = 'player' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Player is not allowed to create events';
  END IF;

  -- Coach can only create for own team
  IF v_role_name = 'coach' THEN
    SELECT c.id INTO v_creator_coach_id
    FROM coaches c
    WHERE c.user_id = p_creator_user_id
    LIMIT 1;

    SELECT t.id INTO v_creator_team_id
    FROM teams t
    WHERE t.coach_id = v_creator_coach_id
    ORDER BY t.id
    LIMIT 1;

    IF v_creator_team_id IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Coach has no assigned team';
    END IF;

    SET p_is_all_teams = 0;
    SET p_team_ids_csv = CAST(v_creator_team_id AS CHAR);
  END IF;

  -- Admin/Coach specific-target event requires at least one team id
  IF p_is_all_teams = 0 AND (p_team_ids_csv IS NULL OR TRIM(p_team_ids_csv) = '') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least one team must be selected';
  END IF;

  -- Store nullable team_id for backward compatibility:
  -- all teams = NULL, specific teams = first team from list
  IF p_is_all_teams = 0 THEN
    SET v_first_team_id = CAST(SUBSTRING_INDEX(TRIM(p_team_ids_csv), ',', 1) AS UNSIGNED);
  END IF;

  INSERT INTO calendar_events (
    title, event_type, comment, event_date, event_time, team_id, created_by
  ) VALUES (
    p_title, p_event_type, p_comment, p_event_date, p_event_time, IF(p_is_all_teams = 1, NULL, v_first_team_id), p_creator_user_id
  );

  SET v_event_id = LAST_INSERT_ID();

  -- Save explicit team mapping for specific-team events
  IF p_is_all_teams = 0 THEN
    SET v_csv = TRIM(BOTH ',' FROM REPLACE(p_team_ids_csv, ' ', ''));

    WHILE v_csv IS NOT NULL AND v_csv <> '' DO
      SET v_token = SUBSTRING_INDEX(v_csv, ',', 1);

      IF v_token REGEXP '^[0-9]+$' THEN
        INSERT IGNORE INTO calendar_event_teams (event_id, team_id)
        SELECT v_event_id, CAST(v_token AS UNSIGNED)
        FROM teams
        WHERE id = CAST(v_token AS UNSIGNED);
      END IF;

      IF INSTR(v_csv, ',') > 0 THEN
        SET v_csv = SUBSTRING(v_csv, INSTR(v_csv, ',') + 1);
      ELSE
        SET v_csv = '';
      END IF;
    END WHILE;

    SELECT COUNT(*) INTO v_target_count
    FROM calendar_event_teams
    WHERE event_id = v_event_id;

    IF v_target_count = 0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No valid team ids were provided';
    END IF;
  END IF;

  IF p_is_all_teams = 1 THEN
    SET v_message = CONCAT('New event "', p_title, '" is scheduled for all teams.');
  ELSE
    SET v_message = CONCAT('New event "', p_title, '" is scheduled for selected team(s).');
  END IF;

  -- All teams: notify all coaches and players
  IF p_is_all_teams = 1 THEN
    INSERT INTO notifications (user_id, event_id, title, message, is_read)
    SELECT u.id, v_event_id, 'New Calendar Event', v_message, 0
    FROM users u
    JOIN roles r ON r.id = u.role_id
    WHERE r.name IN ('coach', 'player');

    INSERT INTO calendar_event_recipients (event_id, user_id)
    SELECT v_event_id, u.id
    FROM users u
    JOIN roles r ON r.id = u.role_id
    WHERE r.name IN ('coach', 'player');
  ELSE
    -- Specific one/multiple teams: notify coaches + players in selected teams
    INSERT INTO notifications (user_id, event_id, title, message, is_read)
    SELECT DISTINCT u.id, v_event_id, 'New Calendar Event', v_message, 0
    FROM calendar_event_teams cet
    JOIN teams t ON t.id = cet.team_id
    LEFT JOIN coaches c ON c.id = t.coach_id
    LEFT JOIN users u_coach ON u_coach.id = c.user_id
    LEFT JOIN team_players tp ON tp.team_id = t.id
    LEFT JOIN players p ON p.id = tp.player_id
    LEFT JOIN users u_player ON u_player.id = p.user_id
    JOIN users u ON u.id IN (u_coach.id, u_player.id)
    WHERE cet.event_id = v_event_id;

    INSERT INTO calendar_event_recipients (event_id, user_id)
    SELECT DISTINCT v_event_id, u.id
    FROM calendar_event_teams cet
    JOIN teams t ON t.id = cet.team_id
    LEFT JOIN coaches c ON c.id = t.coach_id
    LEFT JOIN users u_coach ON u_coach.id = c.user_id
    LEFT JOIN team_players tp ON tp.team_id = t.id
    LEFT JOIN players p ON p.id = tp.player_id
    LEFT JOIN users u_player ON u_player.id = p.user_id
    JOIN users u ON u.id IN (u_coach.id, u_player.id)
    WHERE cet.event_id = v_event_id;
  END IF;
END $$
DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
