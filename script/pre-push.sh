#!/bin/sh
# Corre Rubocop y Rspec antes de pushear. Se instala con `script/install-hooks.sh`.
# Para saltearlo en un push puntual: git push --no-verify

set -e

azul() { printf '\033[34m%s\033[0m\n' "$1"; }
rojo() { printf '\033[31m%s\033[0m\n' "$1"; }

azul 'Running Rubocop'
if ! bundle exec rubocop --parallel --format simple; then
  rojo "Can't push! You have rubocop offences!!!"
  exit 1
fi

azul 'Running Rspec tests'
if ! bundle exec rspec; then
  rojo "Can't push! You've broken Rspec tests!!!"
  exit 1
fi

azul "All checks passed. You didn't break anything. Congrats!"
exit 0
