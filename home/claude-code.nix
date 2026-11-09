_: {
  # settings.json becomes a read-only link: changes made inside Claude Code
  # (/config, default model, effort level) are no longer saved, change them here
  programs.claude-code = {
    enable = true;
    package = null; # the CLI comes from the claude-code cask
    settings = {
      model = "opus";
      theme = "auto";
      editorMode = "vim";
      agentPushNotifEnabled = true;
      modelSettings = {
        claude-opus-5.effortLevel = "low";
        claude-opus-5-5.effortLevel = "high";
      };
      enabledPlugins."pyright-lsp@claude-plugins-official" = true;
      # no Claude attribution in commits and PRs
      attribution = {
        commit = "";
        pr = "";
      };
      includeCoAuthoredBy = false;
    };
  };
}
