#!/usr/bin/env bash
#
# Fails if a layer imports a module it must not depend on.
#
# Package.swift declares the dependency graph, but Xcode builds every module of the
# package into the same products folder, so an undeclared import (e.g. `import ArtFinderData`
# inside Presentation) can still compile locally. This check makes the rules explicit.
#
# Usage: ./scripts/check-architecture.sh

set -euo pipefail

SOURCES="$(cd "$(dirname "$0")/.." && pwd)/ArtFinderKit/Sources"
violations=0

# check <layer> <forbidden module>...
check() {
    local layer=$1
    shift
    for module in "$@"; do
        if grep -rnE "^[[:space:]]*(@testable[[:space:]]+)?import[[:space:]]+${module}([[:space:]]|$)" "$SOURCES/$layer"; then
            echo "error: $layer must not import $module"
            violations=$((violations + 1))
        fi
    done
}

check ArtFinderDomain ArtFinderData ArtFinderPresentation SwiftUI UIKit
check ArtFinderData ArtFinderPresentation SwiftUI UIKit
check ArtFinderPresentation ArtFinderData

if [ "$violations" -gt 0 ]; then
    exit 1
fi

echo "Architecture check passed: every layer only imports what it depends on."
