{ config, lib, pkgs, theme, ... }:

let
  rofiConfig = ''
    configuration {
      modi: "drun,run,window";
      show-icons: true;
      terminal: "alacritty";
      drun-display-format: "{name}";
      hover-select: false;
      kb-row-select: "Tab";
      kb-cancel: "Escape,Control+g";
      font: "${theme.font.sans} 12";
    }

    * {
      bg: #${theme.base}f2;
      bg-alt: #${theme.surface0}ff;
      fg: #${theme.text}ff;
      fg-muted: #${theme.subtext0}ff;
      border: #${theme.blue}ff;
      urgent: #${theme.red}ff;
      selected: #${theme.surface1}ff;
      active: #${theme.green}ff;
      prompt: #${theme.blue}ff;
    }

    window {
      location: center;
      width: 34%;
      border: 2px;
      border-radius: 16px;
      border-color: @border;
      background-color: @bg;
      padding: 18px;
    }

    mainbox {
      spacing: 14px;
      children: [ "inputbar", "listview" ];
    }

    inputbar {
      background-color: @bg-alt;
      border-radius: 12px;
      padding: 10px 12px;
      children: [ "prompt", "entry" ];
      spacing: 10px;
    }

    prompt {
      text-color: @prompt;
    }

    entry {
      text-color: @fg;
      placeholder: "Search";
      placeholder-color: @fg-muted;
    }

    listview {
      lines: 10;
      columns: 1;
      fixed-height: false;
      background-color: transparent;
      scrollbar: false;
      spacing: 8px;
    }

    element {
      background-color: transparent;
      text-color: @fg;
      border-radius: 12px;
      padding: 10px 12px;
    }

    element selected.normal {
      background-color: @selected;
      text-color: @fg;
    }

    element selected.urgent {
      background-color: @urgent;
      text-color: #${theme.crust}ff;
    }

    element-icon {
      size: 1.05em;
      vertical-align: 0.5;
    }

    element-text {
      text-color: inherit;
    }
  '';
in {
  home.file.".config/rofi/config.rasi".text = rofiConfig;
}
