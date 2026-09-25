#!/usr/bin/env bash
# Installs the pinned, headless toolchain used by every pipeline step.
# Same script runs locally (Linux) and in GitHub Actions.
set -euo pipefail
BLENDER_VERSION="${BLENDER_VERSION:-5.2.2}"
TOOLS_DIR="${TOOLS_DIR:-$(cd "$(dirname "$0")" && pwd)/cache/tools}"
series="${BLENDER_VERSION%.*}"
# Software OpenGL/EGL so Blender can render review previews on GPU-less Linux (CI, containers).
if ! ldconfig -p | grep -q libEGL.so.1; then
  SUDO=$([ "$(id -u)" = 0 ] && echo "" || echo sudo)
  $SUDO apt-get update -q && $SUDO apt-get install -y -q libegl1 libopengl0 libgl1 libglu1-mesa libxi6 libxxf86vm1 libxfixes3 libxrender1 libsm6 libxkbcommon0
fi
dir="$TOOLS_DIR/blender-${BLENDER_VERSION}-linux-x64"
if [ ! -x "$dir/blender" ]; then
  mkdir -p "$TOOLS_DIR"
  curl -fsSL "https://download.blender.org/release/Blender${series}/blender-${BLENDER_VERSION}-linux-x64.tar.xz" | tar -xJ -C "$TOOLS_DIR"
fi
python3 -m pip install -q -r "$(dirname "$0")/requirements.txt"
echo "BLENDER=$dir/blender"
