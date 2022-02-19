#!/usr/bin/env bash
# Copyright © 2022 Hugo Locurcio and contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -xeuo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$#" == 0 ]]; then
  echo "Usage: ./download-all.sh <major.minor> [status]"
  echo "Example: ./download-all.sh 3.1.2"
  echo "         ./download-all.sh 3.2 beta2"
  exit 1
fi

if [[ -n "${2+x}" ]]; then
  # Two arguments passed; it's an alpha/beta/RC version.
  if [[ "$2" == "stable" ]]; then
    # Second argument matches the default value (stable).
    FOLDER="$1"
  else
    FOLDER="$1/$2"
  fi
  SUFFIX="$2"
else
  # One argument passed; it's a stable release.
  FOLDER="$1"
  SUFFIX="stable"
fi

# Download standard binaries.

curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/Godot_v$1-${SUFFIX}_export_templates.tpz"
curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/godot-lib.$1.${SUFFIX}.release.aar"

if [[ "$1" != "4.0" ]]; then
  # 4.0 does not have headless/server binaries anymore, as any binary can be used in headless mode now.
  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/Godot_v$1-${SUFFIX}_linux_headless.64.zip" || true
  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/Godot_v$1-${SUFFIX}_linux_server.64.zip" || true
fi

if [[ "$1" != "4.0" && "$1" != "3.2.3" ]]; then
  # 4.0 does not have a web editor download yet, and 3.2.3 didn't either.
  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/Godot_v$1-${SUFFIX}_web_editor.zip"
fi

# 3.2.3 and older.
curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/Godot_v$1-${SUFFIX}_osx.64.zip" || true
# 3.2.4 and newer.
curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/Godot_v$1-${SUFFIX}_osx.universal.zip" || true
curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/Godot_v$1-${SUFFIX}_win32.exe.zip"
curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/Godot_v$1-${SUFFIX}_win64.exe.zip"
if [[ "$1" == "4.0" ]]; then
  # `x11` was renamed to `linux` in 4.0.
  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/Godot_v$1-${SUFFIX}_linux.32.zip"
  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/Godot_v$1-${SUFFIX}_linux.64.zip"
else
  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/Godot_v$1-${SUFFIX}_x11.32.zip"
  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/Godot_v$1-${SUFFIX}_x11.64.zip"
fi

curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/godot-$1-$SUFFIX.tar.xz"
curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/godot-$1-$SUFFIX.tar.xz.sha256"

if [[ "$1" != "4.0" ]]; then
  # Download Mono-enabled binaries.
  # Not available for 4.0 yet.

  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/mono/Godot_v$1-${SUFFIX}_mono_export_templates.tpz"
  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/mono/godot-lib.$1.${SUFFIX}.mono.release.aar"

  # Mono-enabled Linux servers aren't available in 3.1.x.
  curl -LO "https://downloads.tuxfamily.org/godotengine/$FOLDER/mono/Godot_v$1-${SUFFIX}_mono_linux_headless_64.zip"
  curl -LO "https://downloads.tuxfamily.org/godotengine/$FOLDER/mono/Godot_v$1-${SUFFIX}_mono_linux_server_64.zip"

  # 3.3.4 and older.
  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/mono/Godot_v$1-${SUFFIX}_mono_osx.64.zip" || true
  # 3.4 and newer.
  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/mono/Godot_v$1-${SUFFIX}_mono_osx.universal.zip" || true
  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/mono/Godot_v$1-${SUFFIX}_mono_win32.zip"
  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/mono/Godot_v$1-${SUFFIX}_mono_win64.zip"
  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/mono/Godot_v$1-${SUFFIX}_mono_x11_32.zip"
  curl -fLO "https://downloads.tuxfamily.org/godotengine/$FOLDER/mono/Godot_v$1-${SUFFIX}_mono_x11_64.zip"
fi
