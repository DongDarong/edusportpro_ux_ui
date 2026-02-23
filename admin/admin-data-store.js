(function () {
  const KEY_MAP = {
    users: 'edusportpro_users',
    teams: 'edusportpro_teams',
    matches: 'edusportpro_matches',
    trainingSessions: 'edusportpro_training_sessions',
    attendanceRecords: 'edusportpro_attendance_records',
    calendarEvents: 'edusportpro_calendar_events',
    performanceRecords: 'edusportpro_performance_records',
    inventoryItems: 'edusportpro_inventory_items',
    inventoryCategories: 'edusportpro_inventory_categories',
    inventoryRequests: 'edusportpro_inventory_requests',
    notifications: 'edusportpro_notifications',
    players: 'edusportpro_players',
    coaches: 'edusportpro_coaches',
    tournaments: 'edusportpro_tournaments',
    tournamentTeamMap: 'edusportpro_tournament_team_map'
  };

  const DEFAULT_DATA = {
    users: [],
    teams: [],
    matches: [],
    trainingSessions: [],
    attendanceRecords: [],
    calendarEvents: [],
    performanceRecords: [],
    inventoryItems: [],
    inventoryCategories: [],
    inventoryRequests: [],
    notifications: [],
    players: [],
    coaches: [],
    tournaments: [],
    tournamentTeamMap: {}
  };

  let bootstrapPromise = null;

  function safeParse(input, fallback) {
    try {
      const parsed = JSON.parse(input);
      return parsed == null ? fallback : parsed;
    } catch (_) {
      return fallback;
    }
  }

  function sanitizePayload(raw) {
    const data = raw && typeof raw === 'object' ? raw : {};
    return {
      users: Array.isArray(data.users) ? data.users : DEFAULT_DATA.users,
      teams: Array.isArray(data.teams) ? data.teams : DEFAULT_DATA.teams,
      matches: Array.isArray(data.matches) ? data.matches : DEFAULT_DATA.matches,
      trainingSessions: Array.isArray(data.trainingSessions) ? data.trainingSessions : DEFAULT_DATA.trainingSessions,
      attendanceRecords: Array.isArray(data.attendanceRecords) ? data.attendanceRecords : DEFAULT_DATA.attendanceRecords,
      calendarEvents: Array.isArray(data.calendarEvents) ? data.calendarEvents : DEFAULT_DATA.calendarEvents,
      performanceRecords: Array.isArray(data.performanceRecords) ? data.performanceRecords : DEFAULT_DATA.performanceRecords,
      inventoryItems: Array.isArray(data.inventoryItems) ? data.inventoryItems : DEFAULT_DATA.inventoryItems,
      inventoryCategories: Array.isArray(data.inventoryCategories) ? data.inventoryCategories : DEFAULT_DATA.inventoryCategories,
      inventoryRequests: Array.isArray(data.inventoryRequests) ? data.inventoryRequests : DEFAULT_DATA.inventoryRequests,
      notifications: Array.isArray(data.notifications) ? data.notifications : DEFAULT_DATA.notifications,
      players: Array.isArray(data.players) ? data.players : DEFAULT_DATA.players,
      coaches: Array.isArray(data.coaches) ? data.coaches : DEFAULT_DATA.coaches,
      tournaments: Array.isArray(data.tournaments) ? data.tournaments : DEFAULT_DATA.tournaments,
      tournamentTeamMap: data.tournamentTeamMap && typeof data.tournamentTeamMap === 'object' && !Array.isArray(data.tournamentTeamMap)
        ? data.tournamentTeamMap
        : DEFAULT_DATA.tournamentTeamMap
    };
  }

  async function fetchJson(path) {
    try {
      const response = await fetch(path, { cache: 'no-store' });
      if (!response.ok) return DEFAULT_DATA;
      const raw = await response.json();
      return sanitizePayload(raw);
    } catch (_) {
      return DEFAULT_DATA;
    }
  }

  function setEntity(entity, value) {
    if (!KEY_MAP[entity]) return;
    localStorage.setItem(KEY_MAP[entity], JSON.stringify(value));
  }

  function getArray(entity, fallback) {
    const parsed = safeParse(localStorage.getItem(KEY_MAP[entity]), fallback);
    return Array.isArray(parsed) ? parsed : fallback;
  }

  function getObject(entity, fallback) {
    const parsed = safeParse(localStorage.getItem(KEY_MAP[entity]), fallback);
    return parsed && typeof parsed === 'object' && !Array.isArray(parsed) ? parsed : fallback;
  }

  function hasStoredEntity(entity) {
    return localStorage.getItem(KEY_MAP[entity]) != null;
  }

  async function syncFromJson(options) {
    const config = Object.assign({ jsonPath: '/data.json' }, options || {});
    const payload = await fetchJson(config.jsonPath);
    Object.keys(KEY_MAP).forEach(function (entity) {
      setEntity(entity, payload[entity]);
    });
    bootstrapPromise = Promise.resolve(payload);
    return payload;
  }

  async function bootstrap(options) {
    const config = Object.assign({ jsonPath: '/data.json', forceSyncFromJson: false }, options || {});
    if (config.forceSyncFromJson) {
      return syncFromJson(config);
    }
    if (bootstrapPromise) return bootstrapPromise;

    bootstrapPromise = (async function () {
      const payload = await fetchJson(config.jsonPath);
      Object.keys(KEY_MAP).forEach(function (entity) {
        if (!hasStoredEntity(entity)) {
          setEntity(entity, payload[entity]);
        }
      });
      return payload;
    })();

    return bootstrapPromise;
  }

  function installSyncButton() {
    if (document.getElementById('adminSyncJsonBtn')) return;

    const button = document.createElement('button');
    button.id = 'adminSyncJsonBtn';
    button.type = 'button';
    button.textContent = 'Sync JSON';
    button.style.position = 'fixed';
    button.style.right = '16px';
    button.style.bottom = '16px';
    button.style.zIndex = '9999';
    button.style.padding = '8px 10px';
    button.style.borderRadius = '8px';
    button.style.border = '1px solid #bae6fd';
    button.style.backgroundColor = '#ffffff';
    button.style.color = '#0369a1';
    button.style.fontSize = '12px';
    button.style.fontWeight = '600';
    button.style.cursor = 'pointer';
    button.style.boxShadow = '0 6px 14px rgba(2, 132, 199, 0.15)';

    button.addEventListener('click', async function () {
      const ok = window.confirm('Sync local admin data from data.json now? This will overwrite current local changes.');
      if (!ok) return;
      button.disabled = true;
      button.textContent = 'Syncing...';
      await syncFromJson();
      window.location.reload();
    });

    document.body.appendChild(button);
  }

  document.addEventListener('DOMContentLoaded', installSyncButton);

  window.AdminDataStore = {
    bootstrap: bootstrap,
    syncFromJson: syncFromJson,
    getArray: getArray,
    getObject: getObject,
    set: setEntity,
    keys: Object.assign({}, KEY_MAP)
  };
})();
