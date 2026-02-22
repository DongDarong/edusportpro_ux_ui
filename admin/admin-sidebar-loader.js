(function () {
  const pageToKey = {
    "admin-dashboard.html": "dashboard",
    "admin-users.html": "users",
    "admin-teams.html": "teams",
    "admin-players.html": "players",
    "admin-matches.html": "matches",
    "admin-match-results.html": "matches",
    "admin-tournament-overview.html": "tournament",
    "create-tournament.html": "tournament",
    "admin-tournament-teams.html": "tournament",
    "admin-division.html": "division",
    "admin-random-groups.html": "division",
    "admin-division-important.html": "division",
    "admin-knockout-bracket.html": "division",
    "admin-training.html": "training",
    "admin-att.html": "attendance",
    "admin-calendar.html": "calendar",
    "admin-performance.html": "performance",
    "admin-inventory.html": "inventory",
    "admin-reports.html": "reports",
  };

  const defaultClasses = [
    "text-gray-600",
    "hover:bg-gray-50",
    "hover:text-hope-dark",
    "transition-colors",
    "group",
  ];
  const activeClasses = ["bg-hope-cyan/10", "text-hope-cyan", "font-semibold"];
  const iconHoverClasses = [
    "group-hover:text-hope-cyan",
    "group-hover:text-hope-lime",
    "group-hover:text-hope-red",
    "group-hover:text-hope-yellow",
  ];

  function inferActiveKey() {
    const fileName = window.location.pathname.split("/").pop();
    return pageToKey[fileName] || "";
  }

  function applyActiveState(sidebar, activeKey) {
    if (!activeKey) return;

    const activeLink = sidebar.querySelector(
      '[data-sidebar-link="' + activeKey + '"]'
    );
    if (!activeLink) return;

    defaultClasses.forEach(function (cls) {
      activeLink.classList.remove(cls);
    });
    activeClasses.forEach(function (cls) {
      activeLink.classList.add(cls);
    });

    const icon = activeLink.querySelector("svg");
    if (!icon) return;
    iconHoverClasses.forEach(function (cls) {
      icon.classList.remove(cls);
    });
  }

  async function fetchComponentHtml() {
    const candidates = [
      "/admin/admin-sidebar-component.html",
      new URL("./admin-sidebar-component.html", window.location.href).toString(),
    ];

    for (const candidate of candidates) {
      try {
        const response = await fetch(candidate, { cache: "no-cache" });
        if (response.ok) return await response.text();
      } catch (_) {}
    }
    return "";
  }

  async function loadAdminSidebar() {
    const sidebars = document.querySelectorAll("aside#sidebar");
    if (!sidebars.length) return;

    let sidebarHtml = "";
    const needsInjection = Array.from(sidebars).some(function (sidebar) {
      return !sidebar.querySelector("nav");
    });

    if (needsInjection) {
      sidebarHtml = await fetchComponentHtml();
    }

    sidebars.forEach(function (sidebar) {
      if (!sidebar.querySelector("nav") && sidebarHtml) {
        sidebar.innerHTML = sidebarHtml;
      }
      applyActiveState(sidebar, sidebar.dataset.active || inferActiveKey());
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    loadAdminSidebar().catch(function (error) {
      console.error(error);
    });
  });
})();
