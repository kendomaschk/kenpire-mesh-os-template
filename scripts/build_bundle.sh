#!/usr/bin/env bash
set -euo pipefail
mkdir -p dist
# build Go CLI (multi-platform is handled in CI; local builds current OS)
( cd go/cmd/kenpire && go build -o ../../../dist/kenpire-mesh )
# assemble portable bundle (zip is our “disk image” bundle for now)
B=dist/kenpire-mesh-bundle
rm -rf "$B"; mkdir -p "$B"
cp -r dist/kenpire-mesh scripts cards proof logs config "$B" 2>/dev/null || true
printf '#!/usr/bin/env bash\n./kenpire-mesh\n' > "$B/run.sh" && chmod +x "$B/run.sh"
( cd dist && zip -r kenpire-mesh-bundle.zip kenpire-mesh-bundle >/dev/null )
echo "📦 Bundle ready: dist/kenpire-mesh-bundle.zip"
