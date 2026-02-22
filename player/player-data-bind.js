(function () {
  const SESSION_KEY = 'edusportpro_current_user';

  function byId(id) {
    return document.getElementById(id);
  }

  function normalize(value) {
    return String(value || '').trim().toLowerCase();
  }

  function initials(name) {
    const parts = String(name || '').trim().split(/\s+/).filter(Boolean);
    if (!parts.length) return 'PL';
    return parts.slice(0, 2).map(function (part) { return part.charAt(0).toUpperCase(); }).join('');
  }

  function readCurrentUser() {
    const sessionRaw = sessionStorage.getItem(SESSION_KEY);
    const localRaw = localStorage.getItem(SESSION_KEY);
    const raw = sessionRaw || localRaw || '';
    if (!raw) return null;
    try {
      const parsed = JSON.parse(raw);
      return parsed && typeof parsed === 'object' ? parsed : null;
    } catch (_) {
      return null;
    }
  }

  function resolvePlayer(currentUser, users, players) {
    if (currentUser) {
      const cid = normalize(currentUser.id);
      const cemail = normalize(currentUser.email);
      const direct = players.find(function (p) {
        return normalize(p.id) === cid || normalize(p.email) === cemail;
      });
      if (direct) return direct;

      const user = users.find(function (u) {
        return normalize(u.id) === cid || normalize(u.email) === cemail;
      });
      if (user) {
        const mapped = players.find(function (p) {
          return normalize(p.email) === normalize(user.email) || normalize(p.name) === normalize(user.name);
        });
        if (mapped) return mapped;
      }
    }
    return players[0] || null;
  }

  function applyNavProfile(player, teamName) {
    if (!player) return;
    const profileAnchors = document.querySelectorAll('a[href="/player/player-profile.html"]');
    profileAnchors.forEach(function (anchor) {
      const nameEl = anchor.querySelector('.text-sm.font-semibold');
      const roleEl = anchor.querySelector('.text-xs.text-gray-500');
      const avatar = anchor.querySelector('.w-8.h-8, .w-9.h-9');

      if (nameEl) nameEl.textContent = player.name || player.id || 'Player';
      if (roleEl) roleEl.textContent = (player.position || 'Player') + (teamName ? (' - ' + teamName) : '');
      if (avatar) avatar.textContent = initials(player.name || player.id);
    });

    const welcome = Array.from(document.querySelectorAll('p')).find(function (p) {
      return normalize(p.textContent).indexOf('welcome back') !== -1;
    });
    if (welcome) {
      welcome.textContent = 'Welcome back, ' + String(player.name || 'Player') + '! Here\'s your overview.';
    }
  }

  function applyNotificationBadge(notifications) {
    const unread = notifications.filter(function (n) { return !n.read; }).length;
    const value = String(unread);
    document.querySelectorAll('a[href="/player/player-notifications.html"] span').forEach(function (el) {
      if (el.className && el.className.indexOf('rounded-full') !== -1) {
        el.textContent = value;
      }
    });
  }

  function applyDashboardStats(player, team, matches, performance) {
    if (!player) return;
    const playerId = String(player.id || '');
    const playerRecords = performance.filter(function (r) { return String(r.playerId || '') === playerId; });
    const goals = playerRecords.reduce(function (sum, r) { return sum + Number(r.goals || 0); }, 0);
    const assists = playerRecords.reduce(function (sum, r) { return sum + Number(r.assists || 0); }, 0);
    const ratings = playerRecords.map(function (r) { return Number(r.rating || 0); }).filter(Number.isFinite);
    const avgRating = ratings.length ? (ratings.reduce(function (a, b) { return a + b; }, 0) / ratings.length) : 0;
    const teamMatches = matches.filter(function (m) {
      return String(m.homeTeamId || '') === String(player.teamId || '') || String(m.awayTeamId || '') === String(player.teamId || '');
    }).length;

    setStatCardValue('Matches', String(teamMatches));
    setStatCardValue('Goals', String(goals));
    setStatCardValue('Assists', String(assists));
    setStatCardValue('Rating', avgRating ? avgRating.toFixed(1) : '0.0');

    const profileName = Array.from(document.querySelectorAll('h2')).find(function (h) {
      return h.className.indexOf('text-xl') !== -1 && normalize(h.textContent).indexOf('dara') !== -1;
    });
    if (profileName) profileName.textContent = player.name || profileName.textContent;

    const teamTag = Array.from(document.querySelectorAll('span')).find(function (s) {
      return normalize(s.textContent).indexOf('team ') === 0;
    });
    if (teamTag && team && team.name) teamTag.textContent = team.name;
  }

  function setStatCardValue(label, value) {
    const labelEl = Array.from(document.querySelectorAll('p')).find(function (p) {
      return normalize(p.textContent) === normalize(label);
    });
    if (!labelEl) return;
    const card = labelEl.closest('div');
    if (!card) return;
    const num = card.querySelector('h2, h3');
    if (num) num.textContent = value;
  }

  function applyTeamPage(player, team, players) {
    if (!team) return;
    const teamNameEl = Array.from(document.querySelectorAll('h2')).find(function (h) {
      return normalize(h.textContent).indexOf('team ') === 0;
    });
    if (teamNameEl) teamNameEl.textContent = team.name || teamNameEl.textContent;

    const squadSize = players.filter(function (p) {
      return String(p.teamId || '') === String(team.id || '');
    }).length;
    const chip = Array.from(document.querySelectorAll('span')).find(function (s) {
      return normalize(s.textContent).indexOf('players') !== -1;
    });
    if (chip) chip.textContent = String(squadSize) + ' Players';
  }

  function applyMatchSchedulePage(player, team, matches) {
    if (!team) return;
    const teamMatches = matches.filter(function (m) {
      return String(m.homeTeamId || '') === String(team.id || '') || String(m.awayTeamId || '') === String(team.id || '');
    }).slice(0, 6);
    const tbody = document.querySelector('table tbody');
    if (!tbody || !teamMatches.length) return;
    tbody.innerHTML = teamMatches.map(function (m) {
      const isHome = String(m.homeTeamId || '') === String(team.id || '');
      const oppId = isHome ? m.awayTeamId : m.homeTeamId;
      const opponent = 'Team ' + String(oppId || '-').replace(/^T0*/, '');
      const when = m.dateTime ? new Date(m.dateTime) : null;
      const dateText = when && !Number.isNaN(when.getTime()) ? when.toLocaleDateString() : '-';
      const timeText = when && !Number.isNaN(when.getTime()) ? when.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : '-';
      return '' +
        '<tr class="hover:bg-gray-50 transition-colors">' +
        '<td class="px-4 md:px-6 py-4 font-medium text-gray-900 whitespace-nowrap">' + opponent + '</td>' +
        '<td class="px-4 md:px-6 py-4 text-gray-600 whitespace-nowrap"><div class="font-medium">' + dateText + '</div><div class="text-xs text-hope-cyan font-semibold">' + timeText + '</div></td>' +
        '<td class="px-4 md:px-6 py-4 text-gray-500 whitespace-nowrap">' + String(m.venue || '-') + '</td>' +
        '<td class="px-4 md:px-6 py-4 text-center whitespace-nowrap"><span class="text-xs font-semibold px-3 py-1 bg-hope-cyan/10 rounded-full">' + String(m.status || 'Scheduled') + '</span></td>' +
        '</tr>';
    }).join('');
  }

  function applyNotificationsPage(notifications) {
    const container = document.querySelector('main');
    if (!container) return;
    const blocks = container.querySelectorAll('h3');
    if (!blocks.length) return;
    const recent = notifications.slice(0, 4);
    recent.forEach(function (n, idx) {
      if (!blocks[idx]) return;
      blocks[idx].textContent = n.title || blocks[idx].textContent;
      const message = blocks[idx].parentElement.querySelector('p.text-gray-600');
      if (message) message.textContent = n.message || message.textContent;
    });
  }

  function applyPerformancePage(player, performance) {
    if (!player) return;
    const rows = performance.filter(function (r) {
      return String(r.playerId || '') === String(player.id || '');
    });
    setStatCardValue('Goals', String(rows.reduce(function (s, r) { return s + Number(r.goals || 0); }, 0)));
    setStatCardValue('Assists', String(rows.reduce(function (s, r) { return s + Number(r.assists || 0); }, 0)));
  }

  function applyTournamentAndDivision(team, tournaments) {
    const h1 = document.querySelector('h1');
    if (!h1) return;
    if (normalize(h1.textContent).indexOf('tournament information') !== -1 && team) {
      const tName = tournaments.find(function (t) {
        return String(t.id || '') === String(team.tournamentId || '');
      });
      const card = Array.from(document.querySelectorAll('p')).find(function (p) {
        return normalize(p.textContent).indexOf('read-only tournament') !== -1;
      });
      if (card && tName) card.textContent = 'Current tournament: ' + String(tName.name || tName.id || '-');
    }
    if (normalize(h1.textContent).indexOf('division information') !== -1 && team) {
      const card = Array.from(document.querySelectorAll('p')).find(function (p) {
        return normalize(p.textContent).indexOf('read-only division') !== -1;
      });
      if (card) card.textContent = 'Current division: ' + String(team.division || '-');
    }
  }

  async function init() {
    if (!window.AdminDataStore) return;
    await window.AdminDataStore.bootstrap();

    const users = window.AdminDataStore.getArray('users', []);
    const players = window.AdminDataStore.getArray('players', []);
    const teams = window.AdminDataStore.getArray('teams', []);
    const matches = window.AdminDataStore.getArray('matches', []);
    const performance = window.AdminDataStore.getArray('performanceRecords', []);
    const notifications = window.AdminDataStore.getArray('notifications', []);
    const tournaments = window.AdminDataStore.getArray('tournaments', []);
    const currentUser = readCurrentUser();
    const player = resolvePlayer(currentUser, users, players);
    const team = player ? teams.find(function (t) { return String(t.id || '') === String(player.teamId || ''); }) : null;

    applyNavProfile(player, team ? team.name : '');
    applyNotificationBadge(notifications);

    const path = window.location.pathname.toLowerCase();
    if (path.indexOf('/player/player-dashboard.html') !== -1) {
      applyDashboardStats(player, team, matches, performance);
    } else if (path.indexOf('/player/player-team.html') !== -1) {
      applyTeamPage(player, team, players);
    } else if (path.indexOf('/player/player-match-schedule.html') !== -1) {
      applyMatchSchedulePage(player, team, matches);
    } else if (path.indexOf('/player/player-notifications.html') !== -1) {
      applyNotificationsPage(notifications);
    } else if (path.indexOf('/player/player-performance.html') !== -1) {
      applyPerformancePage(player, performance);
    } else if (path.indexOf('/player/player-tournament.html') !== -1 || path.indexOf('/player/player-division.html') !== -1) {
      applyTournamentAndDivision(team, tournaments);
    }
  }

  document.addEventListener('DOMContentLoaded', init);
})();
