# macOS configuration with nix-darwin and Home Manager

This repo declares macOS settings, packages and app configuration for the `macOS` Apple Silicon
host and the `kaktus` user. CLI tools and some GUI apps come from nixpkgs; most GUI apps come from
Homebrew casks. The colour scheme is mostly Catppuccin Mocha.

<img width="1280" alt="Desktop screenshot" src="https://github.com/user-attachments/assets/af7b3e24-d8a4-4f94-a0cc-d9816baee0b7" />

## Where things live

| Path | Purpose |
|---|---|
| `flake.nix`, `flake.lock` | Pinned nixpkgs, unstable, nix-darwin, Home Manager and nix-homebrew inputs; `macOS` host |
| `darwin-settings.nix` | macOS defaults, fonts, Nix GC, Touch ID and Control Center activation |
| `brew-pkgs.nix` | Homebrew taps, formulae, casks and App Store apps |
| `home/` | Home Manager packages, shell, editor and application settings |
| `dotfiles/` | Sources for macOS preferences, wallpaper and initial app settings |
| `secrets/` | Optional, local-only files; ignored by Git and never deployed by this flake |
| `extraApps/` | Local, git-ignored installers and sources not managed by the flake |

App settings follow three patterns:

- Home Manager writes app configuration where supported. Its generated files are read-only; edit
  the corresponding `home/*.nix` module, not the generated file.
- `system.defaults.CustomUserPreferences` manages Loop, Vorssaint, Duet, Finder and other macOS
  plist preferences. Control Center layout is applied by an activation script.
- `home/apps.nix` **copies only missing files** for apps that rewrite their own settings:
  Karabiner, KiCad, Inkscape, Thonny, Arduino IDE and Qalculate Qt. Subsequent in-app changes are
  local; copy desired settings back into `dotfiles/apps/` (or `dotfiles/Karabiner/`) to keep them.
  The CLI `qalc` settings are managed separately by Home Manager.

## Daily use

```sh
re                # sudo darwin-rebuild switch --flake ~/Documents/nix#macOS
nix fmt           # format Nix files
nix flake update  # update pinned inputs, including the Homebrew executable
brew upgrade      # upgrade installed Homebrew formulae/casks; re does not auto-upgrade them
```

`nix-homebrew` supplies Homebrew itself and migrates an existing `/opt/homebrew` installation.
`brew-pkgs.nix` lists the packages, while Homebrew updates are deliberately separate from `re`.
Third-party taps are trusted explicitly there; only trust taps whose current and future contents
you accept. The flake assumes `~/Documents/nix`, `/opt/homebrew` and the user `kaktus`.

Keep secrets locally, outside Git. The optional `secrets/` directory, `.env` files and common
private-key formats are ignored; SSH keys belong in `~/.ssh/` and VNC passwords in `~/.vnc/`.
There is no age/sops setup or encrypted secret in this repo. Ignored files are not included in
flake builds or restored on a new Mac: keep a separate trusted backup. `.gitignore` is only a
safety net—review staged files before committing, and never force-add a secret.

## Packages and exceptions

- **qutebrowser:** The app is the installed Homebrew cask; `home/qutebrowser.nix` manages its
  settings with `programs.qutebrowser.package = null`. Its `,m` shortcut uses Nix's `mpv`.
  On this Mac qutebrowser is installed and works. A fresh Mac needs a separate, trusted app
  installer: Homebrew currently disables this cask, and the nixpkgs package is not used here.
- **Claude Code:** The `claude-code` cask supplies the CLI; Home Manager manages its read-only
  settings with `package = null`. Change `home/claude-code.nix` rather than settings in the app.
- **KiCad / KiKit:** KiCad comes from a Homebrew cask. `home/apps.nix` seeds its versioned `10.0`
  preferences only if missing; keep personal libraries and PCM plugins separately. The `kikit`
  wrapper in `home/packages.nix` uses KiCad's bundled Python at `/Applications/KiCad/KiCad.app`
  and installs KiKit to that Python's user site on first use (requires network access). If KiCad
  changes its bundled Python path or major preferences version, update these paths. The KiKit
  PCM plugin must also be installed from inside KiCad.
- **OpenCode:** `home/opencode.nix` uses unstable nixpkgs with a local `node_modules` hash/CA
  override for the macOS build, plus a hash-pinned Vim TUI plugin. Review the override and hashes
  when updating OpenCode; its CLI theme/plugin configuration is `~/.config/opencode/cli.json`.
  Sign in once with `opencode auth login claude-agent` if using the Claude subscription.
- **Other package sources:** OpenSCAD, Pronterface (`printrun`), `rar` and `gcc-arm-embedded` come
  from nixpkgs, not Homebrew. `home/packages.nix` builds `gds3xtrude` and SolidPython from pinned
  PyPI sources in the Python 3.13 environment. Wine/Winetricks and some SDK libraries stay in
  Homebrew intentionally. VS Code's listed extensions come from Home Manager; extensions added
  inside VS Code remain local.
- **Launch and activation:** Home Manager starts Maccy, Vorssaint and WhatsApp at login; Loop
  starts itself. The wallpaper and Control Center/keyboard shortcuts are applied on activation.

### Disabled Homebrew casks on a fresh Mac

`wine-stable`, `gstreamer-runtime` and `qutebrowser` are still listed because they are installed
on this Mac, but Homebrew disables their casks after Gatekeeper checks. A fresh `brew bundle` may
stop on them. Temporarily omit those entries for the first switch, then obtain installers from
trusted sources (WineHQ/Gcenx for Wine, gstreamer.freedesktop.org for GStreamer, and a verified
qutebrowser upstream release or a trusted copy of the existing app). Do not disable Gatekeeper
system-wide. `uvtools` is also disabled but is **not** in the cask list; install it separately if
needed. This repo does not provide a reproducible fresh-Mac qutebrowser install.

## Setting up a new Mac

1. Install the Command Line Tools and Rosetta: `xcode-select --install` and
   `softwareupdate --install-rosetta --agree-to-license`. Install Nix with flakes enabled.
2. Clone this repo to `~/Documents/nix` under the `kaktus` account. Sign in to the App Store
   before activating, otherwise `masApps` may fail. Temporarily omit disabled casks as above.
3. Restore private data from a trusted backup, **never from this public repo**: the required SSH
   keys and `known_hosts` to `~/.ssh/` with appropriate private-key permissions; VNC passwords to
   `~/.vnc/`; and any other local-only secret files. Verify the backup independently; this repo
   cannot restore these values.
4. First switch: `sudo nix run nix-darwin -- switch --flake ~/Documents/nix#macOS`. Subsequent
   switches use `re`. `nix-homebrew` installs Homebrew itself on a fresh Mac.
5. Copy any needed `extraApps/` installers and sources from a trusted backup. That directory is
   ignored by Git and is not a complete, reproducible installer archive.

After the switch, complete the steps macOS or third-party apps cannot do declaratively:

- Grant Accessibility, Input Monitoring, Full Disk Access and App Management permissions where
  prompted for kitty, Karabiner, Loop, Maccy and Vorssaint. Kitty is ad-hoc signed, so permissions
  may need to be granted again after updates. Approve Karabiner-Elements and macFUSE extensions in
  System Settings, then restart if requested.
- Turn on FileVault, sign in to iCloud, set up Focus modes/notifications, add WireGuard tunnels
  and join Wi-Fi networks.
- Install KiCad PCM plugins and personal libraries and sign in to launchers (Steam, Epic,
  CurseForge). Supply any disabled-cask apps and other `extraApps/` tools you need manually.
