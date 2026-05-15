{ pkgs, ... }:

{
  # Ensure your script is available system-wide
  environment.systemPackages = [
    (pkgs.callPackage ./custom-autoupdate.nix {})
  ];

  # ----------------------------
  # 🔥 Enable lingering for user services (IMPORTANT)
  # ----------------------------
  users.users.tomasr = {
    isNormalUser = true;

    # other config...

    linger = true;  # <-- declarative equivalent of `loginctl enable-linger`
  };

  # ----------------------------
  # ✅ 2. Systemd USER service
  # ----------------------------
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

      # 🔥 recommended reliability tweaks
      Nice = 10;
      IOSchedulingClass = "best-effort";
      IOSchedulingPriority = 7;
    };
  };

  # ----------------------------
  # ⏱️ 3. Systemd USER timer
  # ----------------------------
  systemd.user.timers.custom-autoupdate = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnBootSec = "10min";          # run after boot
      OnUnitActiveSec = "6h";       # every 6 hours

      # 🔥 ensures missed runs after shutdown happen
      Persistent = true;

      # avoids thundering herd on boot
      RandomizedDelaySec = "30min";
    };
  };
}
