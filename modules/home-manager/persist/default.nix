{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.modules.persist;
in {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options.modules.persist = {
    enable = lib.mkEnableOption "impermanence";
    directories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Directories to persist";
    };
    files = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Files to persist";
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence."/persist/home/${config.home.username}" = {
      inherit (cfg) files;
      directories = cfg.directories ++ [".config/nix"];
      allowOther = true;
    };
  };
}
