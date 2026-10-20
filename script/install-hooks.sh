#!/bin/sh
# Instala los git hooks del repo. Correr una vez despues de clonar:
#   ./script/install-hooks.sh
#

set -e

RAIZ=$(git rev-parse --show-toplevel)
cd "$RAIZ"

for hook in pre-commit pre-push; do
  chmod +x "script/$hook.sh"
  ln -sf "../../script/$hook.sh" ".git/hooks/$hook"
  printf '\033[34minstalado %s -> script/%s.sh\033[0m\n' "$hook" "$hook"
done

printf '\033[34mlisto. Para saltear un hook puntual: --no-verify\033[0m\n'
