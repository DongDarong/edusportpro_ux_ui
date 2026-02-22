# EduSportPro UX/UI Frontend

EduSportPro is a multi-role sports management frontend prototype for three user groups:
- Admin
- Coach
- Player

It is built as static HTML pages styled with Tailwind CDN and small inline JavaScript for UI interactions (sidebar toggle, modal dialogs, filtering, pagination, and form flow redirects).

## Project Purpose

This project demonstrates the UX/UI flow of a sports organization platform for:
- user and team administration,
- player and match operations,
- attendance and training tracking,
- performance and reporting,
- notifications and profile settings.

## Tech and Structure

- Frontend: static HTML + Tailwind CSS (CDN)
- Scripts: inline vanilla JavaScript in each page
- Assets: `images/logo.jpg`
- SQL schema/data examples: `database/edusportpro.sql`, `database/edusportpros.sql`

## Folder Overview

- `index.html`: role-based sign-in entry page
- `forgot_password.html`, `verify_code.html`, `reset_password.html`: password recovery flow
- `admin/`: admin portal pages
- `coach/`: coach portal pages
- `player/`: player portal pages
- `database/`: SQL dump files for backend schema/sample data

## Pages, Functions, and Use

### 1) Authentication and Entry Pages

1. `index.html`
Function: portal selection and sign-in forms for Admin and Team users.
Used for: entering the system and routing users to role dashboards.

2. `forgot_password.html`
Function: email input to request password reset code.
Used for: starting password recovery.

3. `verify_code.html`
Function: OTP/verification code entry with timer.
Used for: validating password reset request.

4. `reset_password.html`
Function: set new password and confirm.
Used for: completing account password reset.

### 2) Admin Portal Pages (`admin/`)

1. `admin/admin-dashboard.html`
Function: top-level KPI cards, quick stats, and navigation hub.
Used for: monitoring platform status and opening management modules.

2. `admin/admin-users.html`
Function: user list/management with pagination and create-user access.
Used for: managing system users and roles.

3. `admin/admin-user-create.html`
Function: user creation form with account details and credentials.
Used for: onboarding new users (admin/coach/player).

4. `admin/admin-teams.html`
Function: teams table/list with actions and pagination.
Used for: viewing and administering all teams.

5. `admin/admin-team-create.html`
Function: create-team form.
Used for: registering a new team in the system.

6. `admin/admin-team-detail.html`
Function: detailed team profile (members, related links, quick stats).
Used for: reviewing a specific team and opening related player/report pages.

7. `admin/admin-players.html`
Function: player list management with pagination and detail links.
Used for: administering player records.

8. `admin/admin-create-player.html`
Function: player registration form (profile + upload fields).
Used for: adding a new player profile.

9. `admin/admin-player-detail.html`
Function: player profile view with richer details and export/modal interactions.
Used for: reviewing individual player information and documents.

10. `admin/admin-matches.html`
Function: match list/scheduling management with modal and pagination behavior.
Used for: planning and maintaining match schedules.

11. `admin/admin-match-results.html`
Function: result input form and status notifications.
Used for: recording final match outcomes.

12. `admin/admin-training.html`
Function: training session management (add/search/paginate sessions).
Used for: organizing training plans and sessions.

13. `admin/admin-att.html`
Function: attendance management interface.
Used for: tracking player attendance status.

14. `admin/admin-calendar.html`
Function: monthly calendar/event management with add/edit modal.
Used for: scheduling events and visualizing timelines.

15. `admin/admin-performance.html`
Function: performance input/recording page.
Used for: entering and maintaining player performance metrics.

16. `admin/admin-inventory.html`
Function: inventory list/management with modal workflow.
Used for: controlling sports equipment/resources.

17. `admin/admin-reports.html`
Function: report and analytics view.
Used for: reviewing performance and operational insights.

18. `admin/admin-profile.html`
Function: admin profile and settings (including credential UI controls).
Used for: maintaining personal/admin account settings.

19. `admin/admin-notifications.html`
Function: admin notifications feed.
Used for: reviewing alerts, updates, and system messages.

20. `admin/admin-division.html`
Function: division management page.
Used for: organizing teams/players by division.

21. `admin/admin-tournament-overview.html`
Function: tournament overview and list management view.
Used for: reviewing tournaments, deleting entries, and navigating to update/create flow.

22. `admin/create-tournament.html`
Function: tournament create/update form.
Used for: creating a new tournament or editing an existing tournament.

### 3) Coach Portal Pages (`coach/`)

1. `coach/coach-dashboard.html`
Function: coach KPI/summary dashboard and quick links.
Used for: day-to-day coaching overview.

2. `coach/coach-teams.html`
Function: team overview and team-focused actions.
Used for: monitoring assigned teams.

3. `coach/coach-training.html`
Function: training session planning with add/search/filter patterns.
Used for: preparing and managing practices.

4. `coach/coach-att.html`
Function: attendance tracking interface.
Used for: marking and reviewing player attendance.

5. `coach/coach-performance.html`
Function: player performance input.
Used for: recording athlete evaluation metrics.

6. `coach/coach-matches.html`
Function: match schedule management with add/edit modal behavior.
Used for: planning upcoming matches.

7. `coach/coach-calendar.html`
Function: schedule/events calendar with interactive month navigation and conditional comment input for `Other` event type.
Used for: visual planning of training and match events.

8. `coach/coach-inventory.html`
Function: inventory management view for coach context.
Used for: checking and maintaining available equipment.

9. `coach/coach-notifications.html`
Function: notifications feed with filter/delete interaction flows.
Used for: handling reminders and alerts.

10. `coach/coach-profile.html`
Function: coach profile and account settings.
Used for: updating coach information and account preferences.

11. `coach/coach-tournament.html`
Function: tournament information page in read-only mode.
Used for: allowing coaches to check tournament data without edit/delete actions.

12. `coach/coach-division.html`
Function: division and standings page in read-only mode.
Used for: allowing coaches to review division/group standings without edit/delete actions.

### 4) Player Portal Pages (`player/`)

1. `player/player-dashboard.html`
Function: player personal dashboard (overview widgets and shortcuts).
Used for: seeing quick status on schedule/performance context.

2. `player/player-information.html`
Function: player personal information page.
Used for: viewing own profile data.

3. `player/player-team.html`
Function: team information page for player context.
Used for: checking team details and related info.

4. `player/player-match-schedule.html`
Function: match schedule list/calendar-style view.
Used for: tracking upcoming matches.

5. `player/player-performance.html`
Function: performance overview page.
Used for: reviewing personal performance indicators.

6. `player/player-notifications.html`
Function: player notifications center.
Used for: receiving alerts, announcements, and updates.

7. `player/player-profile.html`
Function: profile and account settings.
Used for: managing account preferences and personal settings.

8. `player/player-tournament.html`
Function: tournament information page in read-only mode.
Used for: allowing players to check tournament data without edit/delete actions.

9. `player/player-division.html`
Function: division/standings information page in read-only mode.
Used for: allowing players to review division data without edit/delete actions.

## Database Coverage (`database/edusportpro.sql`)

- Includes base core entities: users, roles, permissions, teams, players, matches, trainings, attendance, performance, notifications.
- Includes Tournament/Division model:
  - `tournaments`, `divisions`, `tournament_divisions`, `groups`, `group_teams`, `standings`
  - `matches` extended with `tournament_id`, `division_id`, `group_id`, `stage`
- Includes calendar model:
  - `calendar_events` with `event_type` (`match`, `training`, `meeting`, `other`) and `comment` for `Other`
- Includes access-control entries for:
  - tournament/division/calendar view/manage permissions
  - role mapping so coach/player can be view-only where required
- Includes API-ready SQL views for direct UI data binding:
  - `vw_tournament_summary`
  - `vw_division_standings`
  - `vw_calendar_events`

## Current Behavior Notes

- This repository is primarily a frontend prototype: most actions are UI-level (mock data + page transitions), not full backend transactions.
- Many pages include responsive sidebar navigation and role-specific menu flows.
- SQL dump `database/edusportpro.sql` now includes schema and seed data for Tournament, Division, and Calendar use-cases.

## How to Run

1. Open `index.html` in a browser.
2. Navigate through Admin/Coach/Player portals via menu links.
3. For realistic local serving, use any static server (for example VS Code Live Server).
