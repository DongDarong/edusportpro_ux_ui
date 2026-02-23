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

  function applyMatchSchedulePage(player, team, matches, teams) {
    if (!team) return;
    const teamId = String(team.id || '');
    const upcomingTbody = byId('playerUpcomingMatchesTbody') || document.querySelector('table tbody');
    const pastTbody = byId('playerPastMatchesTbody');
    if (!upcomingTbody) return;

    const teamMap = {};
    (Array.isArray(teams) ? teams : []).forEach(function (t) {
      teamMap[String(t.id || '')] = String(t.name || t.id || '-');
    });

    const all = (matches || []).filter(function (m) {
      return String(m.homeTeamId || '') === teamId || String(m.awayTeamId || '') === teamId;
    }).map(function (m) {
      const when = m.dateTime ? new Date(m.dateTime) : null;
      const validWhen = when && !Number.isNaN(when.getTime()) ? when : null;
      const hs = Number(m.homeScore);
      const as = Number(m.awayScore);
      const scored = Number.isFinite(hs) && Number.isFinite(as);
      const isPast = scored || normalize(m.status) === 'completed' || (validWhen && validWhen.getTime() < Date.now());
      return { match: m, when: validWhen, scored: scored, isPast: isPast };
    });

    const upcoming = all.filter(function (x) { return !x.isPast; }).sort(function (a, b) {
      if (!a.when && !b.when) return 0;
      if (!a.when) return 1;
      if (!b.when) return -1;
      return a.when.getTime() - b.when.getTime();
    });
    const past = all.filter(function (x) { return x.isPast; }).sort(function (a, b) {
      if (!a.when && !b.when) return 0;
      if (!a.when) return 1;
      if (!b.when) return -1;
      return b.when.getTime() - a.when.getTime();
    });

    const totalEl = byId('playerScheduleTotal');
    const upcomingCountEl = byId('playerScheduleUpcomingCount');
    const pastCountEl = byId('playerSchedulePastCount');
    const nextMatchEl = byId('playerScheduleNextMatch');
    const upcomingBadge = byId('playerUpcomingBadge');
    const pastBadge = byId('playerPastBadge');
    if (totalEl) totalEl.textContent = String(all.length);
    if (upcomingCountEl) upcomingCountEl.textContent = String(upcoming.length);
    if (pastCountEl) pastCountEl.textContent = String(past.length);
    if (upcomingBadge) upcomingBadge.textContent = String(upcoming.length);
    if (pastBadge) pastBadge.textContent = String(past.length);
    if (nextMatchEl) {
      const next = upcoming[0] && upcoming[0].when ? upcoming[0].when : null;
      nextMatchEl.textContent = next
        ? next.toLocaleString([], { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' })
        : '-';
    }

    if (!upcoming.length) {
      upcomingTbody.innerHTML = '<tr><td colspan="4" class="px-4 md:px-6 py-5 text-center text-gray-500">No upcoming matches.</td></tr>';
    } else {
      upcomingTbody.innerHTML = upcoming.map(function (x) {
        const m = x.match;
        const isHome = String(m.homeTeamId || '') === teamId;
        const oppId = isHome ? String(m.awayTeamId || '') : String(m.homeTeamId || '');
        const oppName = teamMap[oppId] || ('Team ' + oppId.replace(/^T0*/, ''));
        const dateText = x.when ? x.when.toLocaleDateString(undefined, { month: 'short', day: 'numeric', year: 'numeric' }) : '-';
        const timeText = x.when ? x.when.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : '-';
        const compType = m.competitionType ? String(m.competitionType).toUpperCase() : 'MATCH';
        return '' +
          '<tr class="hover:bg-gray-50 transition-colors">' +
          '<td class="px-4 md:px-6 py-4 font-medium text-gray-900 flex items-center gap-3 whitespace-nowrap"><div class="w-8 h-8 rounded-full bg-hope-cyan/10 text-hope-cyan flex items-center justify-center font-bold text-xs border border-hope-cyan/20 flex-shrink-0">' + escapeHtml(initials(oppName)) + '</div><div><div class="font-bold">' + escapeHtml(oppName) + '</div><div class="text-xs text-gray-400 font-normal">' + escapeHtml(compType) + '</div></div></td>' +
          '<td class="px-4 md:px-6 py-4 text-gray-600 whitespace-nowrap"><div class="font-medium">' + escapeHtml(dateText) + '</div><div class="text-xs text-hope-cyan font-semibold">' + escapeHtml(timeText) + '</div></td>' +
          '<td class="px-4 md:px-6 py-4 text-gray-500 whitespace-nowrap">' + escapeHtml(m.venue || '-') + '</td>' +
          '<td class="px-4 md:px-6 py-4 text-center whitespace-nowrap"><span class="text-xs font-semibold px-3 py-1 bg-hope-cyan/10 text-hope-cyan rounded-full">' + escapeHtml(m.status || 'Scheduled') + '</span></td>' +
          '</tr>';
      }).join('');
    }

    if (pastTbody) {
      if (!past.length) {
        pastTbody.innerHTML = '<tr><td colspan="5" class="px-4 md:px-6 py-5 text-center text-gray-500">No past results.</td></tr>';
      } else {
        pastTbody.innerHTML = past.map(function (x) {
          const m = x.match;
          const homeId = String(m.homeTeamId || '');
          const awayId = String(m.awayTeamId || '');
          const homeName = teamMap[homeId] || ('Team ' + homeId.replace(/^T0*/, ''));
          const awayName = teamMap[awayId] || ('Team ' + awayId.replace(/^T0*/, ''));
          const dateText = x.when ? x.when.toLocaleDateString(undefined, { month: 'short', day: 'numeric', year: 'numeric' }) : '-';
          let result = 'N/A';
          let resultClass = 'bg-gray-100 text-gray-600 border-gray-200';
          if (x.scored) {
            const isTeamHome = homeId === teamId;
            const teamScore = isTeamHome ? Number(m.homeScore) : Number(m.awayScore);
            const oppScore = isTeamHome ? Number(m.awayScore) : Number(m.homeScore);
            if (teamScore > oppScore) {
              result = 'WIN';
              resultClass = 'bg-green-100 text-green-700 border-green-200';
            } else if (teamScore < oppScore) {
              result = 'LOSS';
              resultClass = 'bg-red-100 text-red-700 border-red-200';
            } else {
              result = 'DRAW';
              resultClass = 'bg-gray-100 text-gray-600 border-gray-200';
            }
          }
          const scoreText = x.scored ? (String(m.homeScore) + ' - ' + String(m.awayScore)) : '-';
          return '' +
            '<tr class="hover:bg-gray-50 transition-colors">' +
            '<td class="px-4 md:px-6 py-4 font-medium text-gray-900 whitespace-nowrap">' + escapeHtml(homeName) + ' <span class="text-gray-400 mx-1">vs</span> ' + escapeHtml(awayName) + '</td>' +
            '<td class="px-4 md:px-6 py-4 text-gray-600 whitespace-nowrap">' + escapeHtml(dateText) + '</td>' +
            '<td class="px-4 md:px-6 py-4 text-center whitespace-nowrap"><span class="px-2 py-1 rounded text-xs font-bold border ' + resultClass + '">' + escapeHtml(result) + '</span></td>' +
            '<td class="px-4 md:px-6 py-4 text-center font-mono font-bold text-gray-800 whitespace-nowrap">' + escapeHtml(scoreText) + '</td>' +
            '<td class="px-4 md:px-6 py-4 text-gray-500 whitespace-nowrap">' + escapeHtml(m.venue || '-') + '</td>' +
            '</tr>';
        }).join('');
      }
    }
  }

  function applyNotificationsPage(notifications) {
    const list = byId('playerNotificationsList');
    if (!list) return;
    const rows = Array.isArray(notifications) ? notifications.slice() : [];
    if (!rows.length) {
      list.innerHTML = '<div class="bg-white shadow-sm rounded-xl p-4 md:p-5 border border-gray-100 text-sm text-gray-500">No notifications found.</div>';
      return;
    }

    function typeStyle(type, unread) {
      const t = normalize(type);
      const dim = unread ? '' : ' opacity-75';
      if (t === 'matches') return { border: 'border-hope-yellow' + dim, iconBg: 'bg-yellow-50', iconText: 'text-hope-yellow' };
      if (t === 'training') return { border: 'border-hope-cyan' + dim, iconBg: 'bg-cyan-50', iconText: 'text-hope-cyan' };
      if (t === 'inventory' || t === 'performance') return { border: 'border-hope-lime' + dim, iconBg: 'bg-lime-50', iconText: 'text-hope-lime' };
      return { border: 'border-gray-400' + dim, iconBg: 'bg-gray-100', iconText: 'text-gray-500' };
    }

    function timeAgo(value) {
      const d = value ? new Date(value) : null;
      if (!d || Number.isNaN(d.getTime())) return '-';
      const diff = Date.now() - d.getTime();
      if (diff < 60000) return 'just now';
      const mins = Math.floor(diff / 60000);
      if (mins < 60) return mins + ' min ago';
      const hrs = Math.floor(mins / 60);
      if (hrs < 24) return hrs + ' hour' + (hrs > 1 ? 's' : '') + ' ago';
      const days = Math.floor(hrs / 24);
      if (days < 7) return days + ' day' + (days > 1 ? 's' : '') + ' ago';
      return d.toLocaleDateString(undefined, { month: 'short', day: 'numeric', year: 'numeric' });
    }

    list.innerHTML = rows.sort(function (a, b) {
      const at = a && a.createdAt ? new Date(a.createdAt).getTime() : 0;
      const bt = b && b.createdAt ? new Date(b.createdAt).getTime() : 0;
      return bt - at;
    }).map(function (n) {
      const unread = !n.read;
      const style = typeStyle(n.type, unread);
      return '' +
        '<div class="bg-white shadow-sm rounded-xl p-4 md:p-5 border-l-4 ' + style.border + ' flex flex-col sm:flex-row justify-between gap-4 hover:shadow-md transition-shadow group">' +
        '<div class="flex gap-4">' +
        '<div class="flex-shrink-0 mt-1"><div class="w-10 h-10 rounded-full ' + style.iconBg + ' flex items-center justify-center ' + style.iconText + '">' +
        '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>' +
        '</div></div>' +
        '<div><h3 class="text-base md:text-lg font-bold text-gray-900">' + escapeHtml(n.title || 'Notification') + '</h3>' +
        '<p class="text-gray-600 text-sm mt-1">' + escapeHtml(n.message || '-') + '</p>' +
        '<p class="text-gray-400 text-xs mt-2">' + escapeHtml(timeAgo(n.createdAt)) + '</p></div>' +
        '</div>' +
        '<div class="text-xs font-semibold ' + (unread ? 'text-hope-cyan' : 'text-gray-400') + ' self-start sm:self-center">' + (unread ? 'UNREAD' : 'READ') + '</div>' +
        '</div>';
    }).join('');
  }

  function ratingBadgeClass(rating) {
    const n = Number(rating || 0);
    if (n >= 8) return 'bg-green-100 text-green-700 border-green-200';
    if (n >= 7) return 'bg-yellow-100 text-yellow-700 border-yellow-200';
    return 'bg-gray-100 text-gray-700 border-gray-200';
  }

  function formatDate(value) {
    if (!value) return '-';
    const d = new Date(value);
    if (Number.isNaN(d.getTime())) return String(value);
    return d.toLocaleDateString(undefined, { month: 'short', day: 'numeric', year: 'numeric' });
  }

  function escapeHtml(value) {
    return String(value == null ? '' : value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function renderTeamLogo(team) {
    const name = String((team && (team.name || team.id)) || 'Team');
    const logoSrc = team && (team.logo || team.logoUrl || team.badge || '');
    if (logoSrc) {
      return '' +
        '<img src="' + escapeHtml(logoSrc) + '" alt="' + escapeHtml(name) + ' logo" class="w-8 h-8 rounded-full object-cover border border-gray-200 bg-white" />' +
        '';
    }
    return '' +
      '<span class="w-8 h-8 rounded-full inline-flex items-center justify-center bg-hope-cyan/10 text-hope-cyan text-[10px] font-bold border border-hope-cyan/20">' +
      escapeHtml(initials(name)) +
      '</span>';
  }

  function buildMatchRows(matchRows, teamName) {
    if (!matchRows.length) {
      return '<tr><td colspan="6" class="px-4 md:px-6 py-6 text-center text-gray-500">No match performance data.</td></tr>';
    }
    return matchRows.map(function (r) {
      const rating = Number(r.rating || 0);
      return '' +
        '<tr class="hover:bg-gray-50 transition-colors">' +
        '<td class="px-4 md:px-6 py-4 font-medium text-gray-900 whitespace-nowrap">' + escapeHtml(teamName || 'My Team') + ' <span class="text-gray-400 mx-1">vs</span> ' + escapeHtml(r.opponent || '-') + '</td>' +
        '<td class="px-4 md:px-6 py-4 text-gray-600 whitespace-nowrap">' + escapeHtml(formatDate(r.date)) + '</td>' +
        '<td class="px-4 md:px-6 py-4 text-center font-bold text-gray-700 whitespace-nowrap">' + escapeHtml(r.goals || 0) + '</td>' +
        '<td class="px-4 md:px-6 py-4 text-center font-bold text-gray-700 whitespace-nowrap">' + escapeHtml(r.assists || 0) + '</td>' +
        '<td class="px-4 md:px-6 py-4 text-center whitespace-nowrap"><span class="px-2 py-1 rounded text-xs font-bold border ' + ratingBadgeClass(rating) + '">' + (rating ? rating.toFixed(1) : '0.0') + '</span></td>' +
        '<td class="px-4 md:px-6 py-4 text-gray-500 text-xs italic">' + escapeHtml(r.notes || '-') + '</td>' +
        '</tr>';
    }).join('');
  }

  function buildTrainingRows(trainingRows) {
    if (!trainingRows.length) {
      return '<tr><td colspan="5" class="px-4 md:px-6 py-6 text-center text-gray-500">No training performance data.</td></tr>';
    }
    return trainingRows.map(function (r) {
      const rating = Number(r.rating || 0);
      const type = String(r.sessionType || 'training');
      return '' +
        '<tr class="hover:bg-gray-50 transition-colors">' +
        '<td class="px-4 md:px-6 py-4 text-gray-600 whitespace-nowrap">' + escapeHtml(formatDate(r.date)) + '</td>' +
        '<td class="px-4 md:px-6 py-4 font-medium text-gray-900 whitespace-nowrap"><span class="w-2 h-2 rounded-full bg-blue-500 inline-block mr-2"></span>' + escapeHtml(type.charAt(0).toUpperCase() + type.slice(1)) + '</td>' +
        '<td class="px-4 md:px-6 py-4 text-gray-500 whitespace-nowrap">' + escapeHtml(r.opponent || 'Player Development') + '</td>' +
        '<td class="px-4 md:px-6 py-4 text-center whitespace-nowrap"><span class="px-2 py-1 rounded text-xs font-bold border ' + ratingBadgeClass(rating) + '">' + (rating ? rating.toFixed(1) : '0.0') + '</span></td>' +
        '<td class="px-4 md:px-6 py-4 text-gray-500 text-xs">' + escapeHtml(r.notes || '-') + '</td>' +
        '</tr>';
    }).join('');
  }

  function applyPerformancePage(player, team, performance) {
    if (!player) return;
    const rows = performance.filter(function (r) {
      return String(r.playerId || '') === String(player.id || '');
    });
    const matchRows = rows.filter(function (r) { return normalize(r.sessionType) === 'match'; });
    const trainingRows = rows.filter(function (r) { return normalize(r.sessionType) !== 'match'; });

    const totalGoals = rows.reduce(function (sum, r) { return sum + Number(r.goals || 0); }, 0);
    const totalAssists = rows.reduce(function (sum, r) { return sum + Number(r.assists || 0); }, 0);
    const avgRating = rows.length
      ? rows.reduce(function (sum, r) { return sum + Number(r.rating || 0); }, 0) / rows.length
      : 0;

    setStatCardValue('Total Matches', String(matchRows.length));
    setStatCardValue('Goals', String(totalGoals));
    setStatCardValue('Assists', String(totalAssists));
    setStatCardValue('Avg Rating', avgRating.toFixed(1));

    const bodies = document.querySelectorAll('table tbody');
    if (bodies[0]) {
      bodies[0].innerHTML = buildMatchRows(matchRows, team && team.name ? team.name : 'My Team');
    }
    if (bodies[1]) {
      bodies[1].innerHTML = buildTrainingRows(trainingRows);
    }
  }

  function statusBadgeClass(status) {
    const s = normalize(status);
    if (s === 'live') return 'bg-hope-cyan/10 text-hope-cyan';
    if (s === 'upcoming' || s === 'pending') return 'bg-hope-yellow/10 text-hope-yellow';
    if (s === 'scheduled') return 'bg-gray-100 text-gray-700';
    if (s === 'completed') return 'bg-green-100 text-green-700';
    return 'bg-gray-100 text-gray-700';
  }

  function findTournamentIdForTeam(team, tournamentTeamMap) {
    if (!team) return '';
    if (team.tournamentId) return String(team.tournamentId);
    const map = tournamentTeamMap && typeof tournamentTeamMap === 'object' ? tournamentTeamMap : {};
    const teamId = String(team.id || '');
    const keys = Object.keys(map);
    for (var i = 0; i < keys.length; i += 1) {
      var tId = keys[i];
      var teamIds = Array.isArray(map[tId]) ? map[tId] : [];
      if (teamIds.some(function (id) { return String(id) === teamId; })) return tId;
    }
    return '';
  }

  function applyTournamentAndDivision(team, tournaments, matches, tournamentTeamMap, teams) {
    const h1 = document.querySelector('h1');
    if (!h1) return;
    if (normalize(h1.textContent).indexOf('tournament information') !== -1 && team) {
      const card = Array.from(document.querySelectorAll('p')).find(function (p) {
        return normalize(p.textContent).indexOf('read-only tournament') !== -1;
      });
      const heading = Array.from(document.querySelectorAll('h2')).find(function (el) {
        return normalize(el.textContent).indexOf('tournament schedule') !== -1;
      });
      const tbody = byId('playerTournamentTbody') || document.querySelector('table tbody');
      const select = byId('playerTournamentSelect');
      const teamId = String(team.id || '');
      const teamMap = {};
      (Array.isArray(teams) ? teams : []).forEach(function (t) {
        teamMap[String(t.id || '')] = String(t.name || t.id || '-');
      });
      const currentTournamentId = findTournamentIdForTeam(team, tournamentTeamMap);
      const safeTournaments = Array.isArray(tournaments) ? tournaments : [];
      const selectedFallback = currentTournamentId || (safeTournaments[0] ? String(safeTournaments[0].id || '') : '');

      function renderTournamentView(selectedTournamentId) {
        var selectedId = String(selectedTournamentId || '');
        var selectedTournament = safeTournaments.find(function (t) { return String(t.id || '') === selectedId; }) || null;
        var tournamentNameEl = byId('playerTournamentName');
        var tournamentMatchCountEl = byId('playerTournamentMatchCount');
        var tournamentNextMatchEl = byId('playerTournamentNextMatch');
        if (card) {
          card.textContent = 'Current tournament: ' + String(selectedTournament ? (selectedTournament.name || selectedTournament.id || '-') : '-');
        }
        if (heading) {
          heading.textContent = String(selectedTournament ? (selectedTournament.name || selectedTournament.id || 'Tournament') : 'Tournament') + ' Schedule';
        }
        if (tournamentNameEl) {
          tournamentNameEl.textContent = String(selectedTournament ? (selectedTournament.name || selectedTournament.id || '-') : '-');
        }
        if (!tbody) return;

        const rows = (matches || []).filter(function (m) {
          const includesTeam = String(m.homeTeamId || '') === teamId || String(m.awayTeamId || '') === teamId;
          if (!includesTeam) return false;
          if (!selectedId) return true;
          return String(m.tournamentId || '') === selectedId;
        });
        if (tournamentMatchCountEl) tournamentMatchCountEl.textContent = String(rows.length);

        const upcoming = rows
          .map(function (m) {
            const dt = m.dateTime ? new Date(m.dateTime) : null;
            return dt && !Number.isNaN(dt.getTime()) ? dt : null;
          })
          .filter(function (d) { return !!d; })
          .sort(function (a, b) { return a.getTime() - b.getTime(); });
        if (tournamentNextMatchEl) {
          tournamentNextMatchEl.textContent = upcoming.length
            ? upcoming[0].toLocaleString([], { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' })
            : '-';
        }

        if (!rows.length) {
          tbody.innerHTML = '<tr><td colspan="5" class="py-4 px-4 text-center text-gray-500">No tournament matches available.</td></tr>';
          return;
        }

        tbody.innerHTML = rows.map(function (m) {
          const home = String(m.homeTeamId || 'Team A');
          const away = String(m.awayTeamId || 'Team B');
          const homeName = teamMap[home] || ('Team ' + home.replace(/^T0*/, ''));
          const awayName = teamMap[away] || ('Team ' + away.replace(/^T0*/, ''));
          const matchLabel = homeName + ' vs ' + awayName;
          const kickoff = m.dateTime ? new Date(m.dateTime) : null;
          const dateTime = kickoff && !Number.isNaN(kickoff.getTime())
            ? kickoff.toLocaleString([], { month: 'short', day: 'numeric', year: 'numeric', hour: '2-digit', minute: '2-digit' })
            : formatDate(m.dateTime);
          return '' +
            '<tr>' +
            '<td class="py-3 px-4 font-medium text-gray-700">' + escapeHtml(m.id || '-') + '</td>' +
            '<td class="py-3 px-4">' + escapeHtml(matchLabel) + '</td>' +
            '<td class="py-3 px-4">' + escapeHtml(dateTime) + '</td>' +
            '<td class="py-3 px-4">' + escapeHtml(m.venue || '-') + '</td>' +
            '<td class="py-3 px-4"><span class="px-2 py-1 rounded-full text-xs ' + statusBadgeClass(m.status) + '">' + escapeHtml(m.status || 'Scheduled') + '</span></td>' +
            '</tr>';
        }).join('');
      }

      if (select) {
        const optionHtml = safeTournaments.map(function (t) {
          const tid = String(t.id || '');
          const selected = tid === selectedFallback ? ' selected' : '';
          return '<option value="' + escapeHtml(tid) + '"' + selected + '>' + escapeHtml(t.name || tid) + '</option>';
        }).join('');
        select.innerHTML = optionHtml || '<option value="">No tournaments</option>';
        if (!select.dataset.bound) {
          select.addEventListener('change', function () {
            renderTournamentView(select.value);
          });
          select.dataset.bound = '1';
        }
        renderTournamentView(select.value || selectedFallback);
      } else {
        renderTournamentView(selectedFallback);
      }
    }
    if (normalize(h1.textContent).indexOf('division information') !== -1 && team) {
      const card = Array.from(document.querySelectorAll('p')).find(function (p) {
        return normalize(p.textContent).indexOf('read-only division') !== -1;
      });
      if (card) card.textContent = 'Current division: ' + String(team.division || '-');

      const heading = Array.from(document.querySelectorAll('h2')).find(function (el) {
        return normalize(el.textContent).indexOf('division standings') !== -1;
      });
      if (heading) heading.textContent = 'Division Standings - ' + String(team.division || '-');
      const divisionName = byId('playerDivisionName');
      if (divisionName) divisionName.textContent = String(team.division || '-');

      const tbody = byId('playerDivisionTbody') || document.querySelector('table tbody');
      if (!tbody) return;

      const divisionTeams = (Array.isArray(teams) ? teams : []).filter(function (t) {
        return String(t.division || '') === String(team.division || '');
      });
      const teamCountEl = byId('playerDivisionTeamCount');
      if (teamCountEl) teamCountEl.textContent = String(divisionTeams.length);

      const stats = {};
      divisionTeams.forEach(function (t) {
        stats[String(t.id || '')] = { played: 0, points: 0 };
      });

      (matches || []).forEach(function (m) {
        const homeId = String(m.homeTeamId || '');
        const awayId = String(m.awayTeamId || '');
        const home = stats[homeId];
        const away = stats[awayId];
        if (!home && !away) return;

        if (home) home.played += 1;
        if (away) away.played += 1;

        const hs = Number(m.homeScore);
        const as = Number(m.awayScore);
        const scored = Number.isFinite(hs) && Number.isFinite(as);
        if (!scored) return;

        if (home && away) {
          if (hs > as) home.points += 3;
          else if (as > hs) away.points += 3;
          else {
            home.points += 1;
            away.points += 1;
          }
        } else if (home) {
          if (hs > as) home.points += 3;
          else if (hs === as) home.points += 1;
        } else if (away) {
          if (as > hs) away.points += 3;
          else if (as === hs) away.points += 1;
        }
      });

      const sorted = divisionTeams.slice().sort(function (a, b) {
        const sa = stats[String(a.id || '')] || { played: 0, points: 0 };
        const sb = stats[String(b.id || '')] || { played: 0, points: 0 };
        if (sb.points !== sa.points) return sb.points - sa.points;
        if (sb.played !== sa.played) return sb.played - sa.played;
        return String(a.name || '').localeCompare(String(b.name || ''));
      });
      const totalTrackedMatches = sorted.reduce(function (sum, t) {
        const s = stats[String(t.id || '')] || { played: 0 };
        return sum + Number(s.played || 0);
      }, 0);
      const matchCountEl = byId('playerDivisionMatchCount');
      if (matchCountEl) matchCountEl.textContent = String(Math.floor(totalTrackedMatches / 2));

      if (!sorted.length) {
        tbody.innerHTML = '<tr><td colspan="5" class="py-4 px-4 text-center text-gray-500">No division standings available.</td></tr>';
        return;
      }

      tbody.innerHTML = sorted.map(function (t, index) {
        const s = stats[String(t.id || '')] || { played: 0, points: 0 };
        const isCurrentTeam = String(t.id || '') === String(team.id || '');
        const rowClass = isCurrentTeam ? 'bg-hope-cyan/5' : '';
        return '' +
          '<tr class="' + rowClass + '">' +
          '<td class="py-3 px-4 text-gray-500 font-semibold">' + escapeHtml(index + 1) + '</td>' +
          '<td class="py-3 px-4 font-medium text-gray-800"><div class="flex items-center gap-3">' + renderTeamLogo(t) + '<span>' + escapeHtml(t.name || t.id || '-') + (isCurrentTeam ? ' <span class="ml-2 text-[10px] uppercase tracking-wide px-2 py-0.5 rounded-full bg-hope-cyan/10 text-hope-cyan border border-hope-cyan/30">Your Team</span>' : '') + '</span></div></td>' +
          '<td class="py-3 px-4">' + escapeHtml(t.division || '-') + '</td>' +
          '<td class="py-3 px-4">' + escapeHtml(s.played) + '</td>' +
          '<td class="py-3 px-4 font-semibold text-hope-dark">' + escapeHtml(s.points) + '</td>' +
          '</tr>';
      }).join('');
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
    const tournamentTeamMap = window.AdminDataStore.getObject('tournamentTeamMap', {});
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
      applyMatchSchedulePage(player, team, matches, teams);
    } else if (path.indexOf('/player/player-notifications.html') !== -1) {
      applyNotificationsPage(notifications);
    } else if (path.indexOf('/player/player-performance.html') !== -1) {
      applyPerformancePage(player, team, performance);
    } else if (path.indexOf('/player/player-tournament.html') !== -1 || path.indexOf('/player/player-division.html') !== -1) {
      applyTournamentAndDivision(team, tournaments, matches, tournamentTeamMap, teams);
    }
  }

  document.addEventListener('DOMContentLoaded', init);
})();
