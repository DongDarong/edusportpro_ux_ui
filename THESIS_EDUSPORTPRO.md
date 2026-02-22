# THESIS TOPIC

## SPORT MANAGEMENT SYSTEM OF THE HOPE FOR CAMBODIAN CHILDREN FOUNDATION

# Chapter 1: Introduction

This project develops a multi-role Sport Management System for the Hope for Cambodian Children Foundation, designed for Admin, Coach, and Player users.  
The project addresses common problems in school/youth sports operations: fragmented records, unclear responsibilities, weak role-based control, and delayed communication.

The system integrates core modules such as users, teams, players, matches, training, attendance, calendar, tournament, division, performance, notifications, inventory, and reports into one platform.

## 1.1 Research Questions

1. How can a role-based web system improve coordination between Admin, Coach, and Player in sports management?
2. How can a centralized data model reduce inconsistency in team, match, attendance, and competition records?
3. How can calendar and notification workflows improve communication accuracy for all-team and team-specific events?
4. How can competition management (Tournament/Division/Groups/Standings) be organized in a scalable and maintainable way?
5. What design approach best supports responsive, usable interfaces for different roles with different permissions?

## 1.2 Research Objectives

### General Objective
Develop and evaluate a centralized, role-based Sport Management System for the Hope for Cambodian Children Foundation.

### Specific Objectives
1. Design and implement a three-role architecture (Admin, Coach, Player) with clear permission boundaries.
2. Build integrated modules for user, team, player, match, training, attendance, calendar, and reporting workflows.
3. Implement competition management structures for Tournament and Division with clear data relationships.
4. Improve communication flow through role-scoped event creation and notification targeting.
5. Provide a consistent and responsive user interface across desktop and mobile layouts.
6. Define database relationships that preserve integrity across all major sports operations.
7. Document implementation logic to support future backend integration and system scaling.

# Chapter 2: Library Science

This chapter reviews related concepts and references used to guide the system design for the Hope for Cambodian Children Foundation.

## 2.1 Role-Based Access Control (RBAC)
RBAC supports separation of duties by assigning permissions according to user role.  
In EduSportPro:
- Admin has organization-wide control.
- Coach has team-scoped operational control.
- Player has read-focused personal/team visibility.

## 2.2 Sports Information Systems
Sports information systems unify scheduling, roster, attendance, and performance data to improve decision-making and reduce manual overhead.

## 2.3 Web-Based Management Systems
Web systems support centralized access, real-time updates, and cross-device usability.  
This aligns with EduSportPro's requirement for responsive interfaces and shared data visibility.

## 2.4 Relational Data Modeling
Relational schema design provides structured links among users, teams, players, matches, and competition entities, enabling consistent reporting and integrity enforcement.

## 2.5 Notification and Event Communication Models
Audience-targeted communication logic ensures the right users receive the right event updates (all teams, selected teams, or coach-team scope).

# Chapter 3: Research Methods

This chapter explains how the system was designed, developed, and validated.

## 3.1 Research Location

The project was developed in an academic software development environment using:
- Frontend workspace for module-based UI implementation.
- Local database design environment for schema and SQL logic.
- Role-based test context for Admin, Coach, and Player workflows.

## 3.2 Research Methods

The project used an applied software engineering approach:

1. Requirement Analysis  
- Collected functional and role-based requirements for sports operations and communication.

2. System Design  
- Designed UI flow per role and module navigation structure.  
- Designed relational database structure for core sports entities.

3. Implementation  
- Built role-specific web pages for Admin, Coach, and Player modules.  
- Implemented module logic and shared UI patterns (e.g., reusable admin sidebar component).

4. Validation and Review  
- Checked role boundaries in UI behavior.  
- Verified module consistency for tournament/division, calendar targeting, and operational pages.  
- Updated documentation files to align with implementation changes.

5. Documentation  
- Produced structured technical documentation for architecture, logic, and future backend enforcement.

## 3.3 Recent Implementation Updates (Frontend Milestone)

The project implementation was expanded with JSON-driven frontend state management and role-aware workflow refinement.

### 3.3.1 Shared JSON Data Layer
- Introduced and standardized `admin/admin-data-store.js` as a shared browser-side data service.
- Core entities are loaded from `data.json` and persisted in local storage for module-level CRUD simulation.
- Admin pages were aligned to consume this store instead of hardcoded/static placeholders.

### 3.3.2 Authentication and Account Flow Updates
- Updated `index.html` login flow to validate users from JSON data and route by role (Admin/Coach/Player).
- Added and integrated password recovery flow:
  - `forgot_password.html` (email validation + reset session generation)
  - `verify_code.html` (code + expiry validation)
  - `reset_password.html` (password update persisted in users data)
- Added and later removed `register.html` based on revised scope decisions.

### 3.3.3 Admin Team Module Enhancements
- `admin/admin-teams.html`
  - Added team logo rendering in list view.
  - `Update` action routes to edit mode with team id query.
- `admin/admin-team-create.html`
  - Supports both create and edit modes.
  - Added team logo upload with preview and validation.
  - Implemented JSON-backed player roster assignment (search, add, remove, clear, display).
  - Added full form clear action.
- `admin/admin-team-detail.html`
  - Loads team detail by URL id from JSON data.
  - Displays team logo and dynamically resolved roster.
  - Added roster search/filter/sort behavior.

### 3.3.4 Division and Competition Pages
- `admin/admin-division.html`
  - Updated to render Matches, Standings, Group Standings, Match List, Player Profile, and Leaderboard from JSON data.
  - Removed `Important Sections` button per updated page architecture.
- `admin/admin-random-groups.html`
  - Converted to JSON-first and then JSON-only data sourcing (seed dataset removed).
  - Random draw now uses teams/coaches/tournaments from shared data store.
- `admin/admin-knockout-bracket.html`
  - Converted from static bracket to JSON-rendered bracket containers and eliminated-team lists.
- Removed deprecated page:
  - `admin/admin-division-important.html`

### 3.3.5 UI/UX Refinements
- `index.html` authentication UI was redesigned while preserving IDs and event bindings.
- Added targeted navigation improvements and consistency fixes across admin pages.
- Corrected placeholder/text rendering and improved form feedback messaging in major auth/team flows.

# Chapter 4: Conclusion

EduSportPro successfully establishes a centralized, role-based sports management platform with clear operational boundaries and integrated workflows.

Key achievements:
1. A complete multi-role structure (Admin, Coach, Player) was defined and implemented.
2. Core sports modules were integrated into a single web project.
3. Tournament and Division management were included as part of competition governance.
4. Communication logic was structured around role and audience scope.
5. A maintainable documentation and component-based frontend approach was introduced.
6. A JSON-backed shared data store now supports cross-module consistency during frontend-stage operation.
7. Team, division, and competition pages were upgraded from static prototypes to dynamic JSON-driven views.

Overall, the project meets its main objective of improving data consistency, role clarity, and operational coordination in sports management.  
Future work should focus on full backend API integration, strict server-side permission enforcement, and automated end-to-end testing.
