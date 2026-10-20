#!/bin/sh
# Corre Rubocop sobre los archivos .rb que estan por commitearse. Se instala con
# `script/install-hooks.sh`. Para saltearlo: git commit --no-verify

set -e

azul() { printf '\033[34m%s\033[0m\n' "$1"; }
rojo() { printf '\033[31m%s\033[0m\n' "$1"; }

ARCHIVOS=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(rb|rake)$|^Gemfile$|^Rakefile$' || true)

if [ -z "$ARCHIVOS" ]; then
  azul 'No staged Ruby files, skipping Rubocop'
  exit 0
fi

azul 'Running Rubocop on staged files'
# --force-exclusion hace que respete el AllCops/Exclude aunque los archivos vengan
# nombrados uno por uno.
if ! echo "$ARCHIVOS" | xargs bundle exec rubocop --force-exclusion --format simple; then
  rojo "Can't commit! You have rubocop offences!!!"
  exit 1
fi

azul 'Rubocop passed'
exit 0
