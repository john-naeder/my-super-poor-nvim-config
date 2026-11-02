# Dependencies

Everything this Neovim config needs to run with all features enabled.

## Quick install (Ubuntu / Debian / Fedora)

```bash
git clone <this-repo> ~/.config/nvim
~/.config/nvim/scripts/install-deps.sh
```

The script is safe to re-run; it only installs what is missing. It does, in order:

1. System packages via `apt` or `dnf` (table below)
2. Node.js 22 from NodeSource when the distro's Node.js is older than 18 (e.g. Ubuntu 22.04)
3. `fd` symlink in `~/.local/bin` on Ubuntu (the package ships it as `fdfind`)
4. `/usr/bin/lldb-dap` symlink when the distro ships a versioned binary (`lldb-dap-18`, ...)
5. Rust via `rustup` + `rustfmt`, `clippy` components
6. Latest Neovim release into `~/.local/opt` + `~/.local/bin/nvim` when Neovim is missing or < 0.12
7. Plugins (`:Lazy! install`), Mason packages, treesitter parsers

Only the Neovim-side part (step 7): `./scripts/install-deps.sh --skip-system`

Afterwards make sure `~/.local/bin` is in `PATH` and your terminal uses a [Nerd Font](https://www.nerdfonts.com/).

## System packages

| Purpose | Ubuntu / Debian | Fedora | Used by |
|---|---|---|---|
| Editor | Neovim **>= 0.12** (release tarball) | Neovim **>= 0.12** (release tarball) | nvim-treesitter `main` branch requires 0.12 |
| Plugin manager | `git` | `git` | lazy.nvim |
| C compiler | `build-essential` | `gcc gcc-c++ make` | compiling treesitter parsers |
| Downloads | `curl wget unzip tar gzip` | `curl wget unzip tar gzip` | Mason, markdown-preview, this script |
| Search | `ripgrep fd-find` | `ripgrep fd-find` | Telescope live grep / find files |
| Node.js >= 18 | `nodejs npm` | `nodejs npm` | Mason npm packages (pyright, ts_ls, yamlls, prettier, ...) |
| Python | `python3 python3-pip python3-venv` | `python3 python3-pip` | Mason pip packages (black, isort, flake8, yamllint, debugpy, ...) |
| Lua rocks | `luarocks` | `luarocks` | Mason `luacheck` |
| C/C++ debugger | `lldb` (+ `/usr/bin/lldb-dap` symlink) | `lldb` | nvim-dap `lldb` adapter (`lua/configs/nvim-dap.lua`) |
| Ansible | `ansible` | `ansible` | `ansiblels`, `ansible-lint` |
| Terminal mux | `tmux` | `tmux` | vim-tmux-navigator |
| Rust | `rustup` + `rustfmt clippy` | `rustup` + `rustfmt clippy` | rustaceanvim, conform `rustfmt`, clippy on save |
| Font | Nerd Font (in the terminal) | Nerd Font (in the terminal) | NvChad UI icons |

WSL only: `~/.local/bin/wsl-open` is used by `lua/options.lua` to open URLs in the Windows browser.

## Mason packages

Installed by the script; most are also auto-installed on demand by `mason-lspconfig`,
`mason-nvim-lint`, `mason-conform` and `mason-nvim-dap`. The list lives in
`MASON_PACKAGES` in `scripts/install-deps.sh`.

| Kind | Packages |
|---|---|
| LSP | `lua-language-server` `clangd` `pyright` `efm` `rust-analyzer` `typescript-language-server` `yaml-language-server` `helm-ls` `json-lsp` `dockerfile-language-server` `docker-compose-language-service` `terraform-ls` `ansible-language-server` `bash-language-server` `html-lsp` `css-lsp` `tailwindcss-language-server` |
| Formatters | `stylua` `clang-format` `black` `isort` `prettier` `shfmt` `taplo` `xmlformatter` `terraform` |
| Linters | `luacheck` `flake8` `cpplint` `yamllint` `ansible-lint` `tflint` `shellcheck` `hadolint` `jsonlint` `markdownlint` |
| Debug adapters | `codelldb` (Rust) `debugpy` (Python) |
| Build tools | `tree-sitter-cli` (required: nvim-treesitter `main` compiles parsers with it) |

## Treesitter parsers

Listed in `lua/configs/treesitter-parsers.lua`, installed automatically on startup
(when `tree-sitter` CLI is available) and by the script.

## Not required

- `lua/configs/preview.lua` is not loaded anywhere, so its tools (zathura, imv, plantuml, pandoc) are not needed.
- `3rd/image.nvim` is disabled (`enabled = false`), so ImageMagick / `magick` rock are not needed.
