{ unstablePkgs, ... }:

{
  xdg.configFile."zed/settings.json".force = true;
  xdg.configFile."zed/keymap.json".force = true;

  programs.zed-editor = {
    enable = true;
    package = unstablePkgs.zed-editor;
    extensions = [ "oxc" ];
    userSettings = {
      disable_ai = false;
      show_edit_predictions = false;
      auto_update = true;
      autosave = "on_focus_change";
      # context_servers = {
      #   nextjs-devtools = {
      #     enabled = true;
      #     command = "bun";
      #     args = [ "x" "next-devtools-mcp@latest" ];
      #     env = { };
      #   };
      #   mcp-server-context7 = {
      #     enabled = true;
      #     settings = {
      #       context7_api_key = "ctx7sk-1ee91ae0-77e0-483e-8c31-3daa69894c02";
      #     };
      #   };
      # };
      icon_theme = "Catppuccin Macchiato";
      agent = {
        tool_permissions = {
          default = "allow";
        };
        favorite_models = [
          {
            provider = "openrouter";
            model = "google/gemini-3-pro-image-preview";
          }
          {
            provider = "openrouter";
            model = "google/gemini-3-pro-preview";
          }
          {
            provider = "openrouter";
            model = "google/gemini-3-flash-preview";
          }
          {
            provider = "google";
            model = "gemini-3-pro-preview";
          }
          {
            provider = "google";
            model = "gemini-3-flash-preview";
          }
        ];
        inline_assistant_model = {
          provider = "openrouter";
          model = "google/gemini-3.1-pro-preview-customtools";
        };
        default_model = {
          provider = "google";
          model = "gemini-3-flash-preview";
        };
        dock = "left";
        model_parameters = [ ];
      };
      outline_panel = {
        button = false;
      };
      collaboration_panel = {
        button = false;
      };
      project_panel = {
        entry_spacing = "comfortable";
        dock = "right";
      };
      agent_buffer_font_size = 12.0;
      agent_ui_font_size = 18.0;
      multi_cursor_modifier = "cmd_or_ctrl";
      buffer_font_family = ".ZedMono";
      ui_font_size = 16;
      buffer_font_size = 16.0;
      theme = {
        mode = "dark";
        dark = "Catppuccin Macchiato";
        light = "Catppuccin Macchiato";
      };
      agent_servers = {
        OpenCode = {
          type = "custom";
          command = "opencode";
          args = [ "acp" ];
        };
      };
    };
    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          ctrl-shift-d = "editor::DuplicateLineDown";
        };
      }
    ];
  };
}
