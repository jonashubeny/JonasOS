# ~/.profile - login shell settings (POSIX sh compatible)

# User - local binaries (pipx, local scripts, etc.)
if [ -d "$HOME/.local/bin" ]; then
  case ":$PATH:" in
  *":$HOME/.local/bin:"*) : ;;
  *) PATH="$HOME/.local/bin:$PATH" ;;
  esac
fi

# Defaults
export EDITOR="${VISUAL:-$EDITOR}"
