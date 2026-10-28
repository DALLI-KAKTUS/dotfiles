{...}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "DALLI-KAKTUS";
      user.email = "berked2003@hotmail.com";
      init.defaultBranch = "main";
    };
    # global gitignore
    ignores = [".DS_Store"];
  };
}
