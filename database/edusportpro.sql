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
-- Database: `edusportpro`
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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
