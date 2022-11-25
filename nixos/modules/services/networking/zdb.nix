{ config, lib, pkgs, ... }: with lib;
let
  cfg = config.services.zdb;

  api = {
    enable = mkEnableOption (lib.mdDoc "zero-db server");
    port = mkOption {
      type        = types.ints.u16;
      default     = 9900;
      description = lib.mdDoc "Server port to listen.";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Open ports in the firewall for zdb";
    };
  };

  imp = {

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services.zdb = {
      description = "zdb daemon";
      unitConfig.Documentation = "man:zdb";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 2;
        DynamicUser = true;
        PrivateDevices = true;
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        ExecStart = ''
          ${pkgs.zdb}/bin/zdb \
            --port ${toString cfg.port} \
            --index /tmp/index \
            --data /tmp/data \
            '';
      };
    };
  };

in {
  options.services.zdb = api;
  config = mkIf cfg.enable imp;
}

