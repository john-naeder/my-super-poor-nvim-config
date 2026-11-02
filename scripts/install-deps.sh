#!/usr/bin/env bash
# Install everything this Neovim config needs, in one go.
# Supports Ubuntu/Debian (apt) and Fedora (dnf). Safe to re-run.
#
#   ./scripts/install-deps.sh               # everything
#   ./scripts/install-deps.sh --skip-system # only Neovim-side (plugins, Mason, parsers)
#
# See DEPENDENCIES.md for what each package is used for.
set -euo pipefail

NVIM_MIN_VERSION="0.12.0"
NODE_MIN_MAJOR=18
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_BIN="$HOME/.local/bin"

# Keep in sync with DEPENDENCIES.md
MASON_PACKAGES=(
  # LSP
  lua-language-server clangd pyright efm rust-analyzer
  typescript-language-server yaml-language-server helm-ls json-lsp
  dockerfile-language-server docker-compose-language-service terraform-ls
  ansible-language-server bash-language-server html-lsp css-lsp
  tailwindcss-language-server
  # Formatters
  stylua clang-format black isort prettier shfmt taplo xmlformatter terraform
  # Linters
  luacheck flake8 cpplint yamllint ansible-lint tflint shellcheck hadolint
  jsonlint markdownlint
  # Debug adapters
  codelldb debugpy
  # Compiles treesitter parsers
  tree-sitter-cli
)

APT_PACKAGES=(
  git build-essential curl wget unzip tar gzip
  ripgrep fd-find
  nodejs npm python3 python3-pip python3-venv
  luarocks lldb ansible tmux
)

DNF_PACKAGES=(
  git gcc gcc-c++ make curl wget unzip tar gzip
  ripgrep fd-find
  nodejs npm python3 python3-pip
  luarocks lldb ansible tmux
)

SKIP_SYSTEM=0
for arg in "$@"; do
  case "$arg" in
    --skip-system) SKIP_SYSTEM=1 ;;
    -h | --help)
      sed -n '2,8p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 1
      ;;
  esac
done

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*" >&2; }

# version_ge A B -> true when A >= B
version_ge() { [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -1)" = "$2" ]; }

detect_pm() {
  # shellcheck disable=SC1091
  . /etc/os-release
  case " ${ID:-} ${ID_LIKE:-} " in
    *" ubuntu "* | *" debian "*) echo apt ;;
    *" fedora "*) echo dnf ;;
    *)
      echo "Unsupported distro: ${PRETTY_NAME:-unknown} (need Ubuntu/Debian or Fedora)" >&2
      exit 1
      ;;
  esac
}

install_system_packages() {
  local pm="$1"
  log "Installing system packages ($pm)"
  if [ "$pm" = apt ]; then
    sudo apt-get update
    sudo apt-get install -y "${APT_PACKAGES[@]}"
  else
    sudo dnf install -y "${DNF_PACKAGES[@]}"
  fi
}

ensure_node() {
  local pm="$1" major=0
  command -v node >/dev/null && major="$(node -p 'process.versions.node.split(".")[0]')"
  if [ "$major" -ge "$NODE_MIN_MAJOR" ]; then
    return
  fi
  log "Node.js $major is too old (need >= $NODE_MIN_MAJOR), installing Node 22 from NodeSource"
  if [ "$pm" = apt ]; then
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt-get install -y nodejs
  else
    curl -fsSL https://rpm.nodesource.com/setup_22.x | sudo bash -
    sudo dnf install -y nodejs
  fi
}

# Ubuntu ships fd as `fdfind`
ensure_fd() {
  if ! command -v fd >/dev/null && command -v fdfind >/dev/null; then
    mkdir -p "$LOCAL_BIN"
    ln -sf "$(command -v fdfind)" "$LOCAL_BIN/fd"
  fi
}

# nvim-dap config expects /usr/bin/lldb-dap; distros often ship it versioned
ensure_lldb_dap() {
  [ -x /usr/bin/lldb-dap ] && return
  local candidate="" f
  for f in /usr/bin/lldb-dap-* /usr/lib/llvm-*/bin/lldb-dap \
    /usr/bin/lldb-vscode-* /usr/lib/llvm-*/bin/lldb-vscode; do
    # globs are sorted, so the last match is the newest LLVM version
    [ -x "$f" ] && candidate="$f"
  done
  if [ -n "$candidate" ]; then
    log "Linking $candidate -> /usr/bin/lldb-dap"
    sudo ln -sf "$candidate" /usr/bin/lldb-dap
  else
    warn "lldb-dap not found; C/C++ debugging will not work"
  fi
}

ensure_rust() {
  if ! command -v rustup >/dev/null; then
    log "Installing Rust toolchain (rustup)"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi
  # shellcheck disable=SC1091
  [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
  log "Adding rustfmt and clippy"
  rustup component add rustfmt clippy
}

ensure_neovim() {
  local current=""
  command -v nvim >/dev/null && current="$(nvim --version | head -1 | sed 's/^NVIM v//; s/-.*//')"
  if [ -n "$current" ] && version_ge "$current" "$NVIM_MIN_VERSION"; then
    log "Neovim $current OK"
    return
  fi

  local arch
  case "$(uname -m)" in
    x86_64) arch=x86_64 ;;
    aarch64 | arm64) arch=arm64 ;;
    *)
      echo "Unsupported architecture: $(uname -m)" >&2
      exit 1
      ;;
  esac
  log "Installing latest Neovim release to ~/.local/opt (found: ${current:-none})"
  mkdir -p "$HOME/.local/opt" "$LOCAL_BIN"
  curl -fL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${arch}.tar.gz" |
    tar -xz -C "$HOME/.local/opt"
  ln -sf "$HOME/.local/opt/nvim-linux-${arch}/bin/nvim" "$LOCAL_BIN/nvim"
  export PATH="$LOCAL_BIN:$PATH"
}

install_nvim_side() {
  log "Installing plugins (lazy.nvim)"
  nvim --headless "+Lazy! install" +qa

  log "Installing Mason packages"
  local list
  list="$(printf '"%s",' "${MASON_PACKAGES[@]}")"
  nvim --headless -c "lua
    require('lazy').load({ plugins = { 'mason.nvim' } })
    local registry = require('mason-registry')
    registry.refresh()
    local missing = {}
    for _, name in ipairs({ ${list} }) do
      if not registry.is_installed(name) then
        table.insert(missing, name)
      end
    end
    if #missing > 0 then
      -- installer stderr (e.g. npm warnings) surfaces as errors; real failures are reported below
      pcall(vim.cmd, 'MasonInstall ' .. table.concat(missing, ' '))
    end
    for _, name in ipairs({ ${list} }) do
      if not registry.is_installed(name) then
        io.stderr:write('Mason package failed: ' .. name .. '\n')
      end
    end" +qa

  log "Installing treesitter parsers"
  nvim --headless -c "lua
    local parsers = require('configs.treesitter-parsers')
    require('nvim-treesitter').install(parsers):wait(600000)
    local installed = require('nvim-treesitter').get_installed()
    for _, lang in ipairs(parsers) do
      if not vim.list_contains(installed, lang) then
        io.stderr:write('Parser failed: ' .. lang .. '\n')
      end
    end" +qa
}

main() {
  if [ "$SKIP_SYSTEM" -eq 0 ]; then
    local pm
    pm="$(detect_pm)"
    install_system_packages "$pm"
    ensure_node "$pm"
    ensure_fd
    ensure_lldb_dap
    ensure_rust
    ensure_neovim
  fi

  case ":$PATH:" in
    *":$LOCAL_BIN:"*) ;;
    *) warn "$LOCAL_BIN is not in PATH; add it to your shell rc" ;;
  esac

  if [ "$(cd "$HOME/.config/nvim" 2>/dev/null && pwd -P)" != "$(cd "$CONFIG_DIR" && pwd -P)" ]; then
    warn "This config is not at ~/.config/nvim; Neovim-side steps will use whatever is there"
  fi
  install_nvim_side

  log "Done. Remember to use a Nerd Font in your terminal."
}

main
