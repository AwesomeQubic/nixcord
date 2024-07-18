self: {
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.nixcord;
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    literalExpression
    ;
in {
  options.programs.nixcord = {
    enable = mkEnableOption "Enables Discord with Vencord";
    package = mkOption {
      type = with types; nullOr package;
      default = pkgs.discord;
      defaultText = literalExpression "pkgs.discord";
      example = literalExpression ''
        pkgs.vesktop
      '';
      description = ''
        The Discord package to use. If using Vesktop instead of
        Discord + Vencord make sure to disable vencord and
        openASAR since they are already part of Vesktop package.
      '';
    };
    configDir = mkOption {
      type = types.path;
      default = "${config.xdg.configHome}/Vencord";
      description = "Vencord config directory";
      example = literalExpression "home/<user>/.config/Vencord";
    };
    vencord.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Vencord";
    };
    openASAR.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable OpenASAR";
    };
    quickCss = mkOption {
      type = types.str;
      default = "";
      description = "Vencord quick CSS";
    };
    config = {
      nofifyAboutUpdates = mkEnableOption "Notify when updates are available";
      autoUpdate = mkEnableOption "Automaticall update Vencord";
      autoUpdateNotification = mkEnableOption "Notify user about auto updates";
      useQuckCSS = mkEnableOption "Enable quick CSS file";
      themeLinks = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = "A list of links to online vencord themes";
        example = [ "https://raw.githubusercontent.com/rose-pine/discord/main/rose-pine.theme.css" ];
      };
      enabledThemes = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = "A list of themes to enable from themes folder";
      };
      enableReactDevtools = mkEnableOption "Enable React developer tools";
      frameless = mkEnableOption "Make client frameless";
      transparent = mkEnableOption "Enable client transparency";
      disableMinSize = mkEnableOption "Disable minimum window size for client";
      plugins = import ./plugins.nix;
    };
    extraConfig = mkOption {
      type = with types; nullOr attrs;
      default = null;
      description = "Vencord config";
    };
  };

  config = mkIf cfg.enable {
    home.packages = cfg.package.override {
      withVencord = cfg.vencord.enable;
      withOpenASAR = cfg.openASAR.enable;
    };
  };
}