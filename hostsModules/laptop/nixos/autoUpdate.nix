{pkgs, ...}: {
  # Ensure your script is available system-wide
  environment.systemPackages = [
    (pkgs.callPackage ../scripts/autoUpdate.nix {})
  ];
  users.users.tomasr = {
    linger = true; # lingering is required
  };

  systemd.user.services.custom-autoupdate = {
    description = "NixOS flake auto update";

    serviceConfig = {
      Type = "oneshot";

      ExecStart = "/run/current-system/sw/bin/custom-autoupdate";

      # safety for long rebuilds
      TimeoutStartSec = "45min";
      TimeoutStopSec = "10min";

      # avoid overlap
      RemainAfterExit = true;

      # tweaks that should make the system run normally during the rebuilds
      Nice = 10;
      IOSchedulingClass = "best-effort";
      IOSchedulingPriority = 7;
    };
  };

  # Systemd USER timer
  systemd.user.timers.custom-autoupdate = {
    wantedBy = ["timers.target"];

    timerConfig = {
      OnCalendar = "Fri *-*-* 20:00:00"; # runs friday night. If for whatever reason something breaks. I have whole week-end to fix it.

      Persistent = true; # if it happens during shutted down

      # avoids thundering herd on boot
      RandomizedDelaySec = "2h";
    };
  };
}
