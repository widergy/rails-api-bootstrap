# Comandos de desarrollo compartidos: https://github.com/widergy/dev-makefiles
# Corré `make` para ver los comandos disponibles.

MK_TYPE    := ruby-consumer
MK_VERSION := v0.3.0
MK_DIR     := $(or $(MK_LOCAL),.make/$(MK_VERSION))

.make/$(MK_VERSION)/%.mk:
	@GIT_TERMINAL_PROMPT=0 git -c advice.detachedHead=false clone -q --depth 1 --branch $(MK_VERSION) git@github.com:widergy/dev-makefiles.git .make/$(MK_VERSION) 2>/dev/null \
		|| { rm -rf .make/$(MK_VERSION); GIT_TERMINAL_PROMPT=0 git -c advice.detachedHead=false clone -q --depth 1 --branch $(MK_VERSION) https://github.com/widergy/dev-makefiles.git .make/$(MK_VERSION); } \
		|| { echo "No se pudo descargar dev-makefiles $(MK_VERSION) ni por SSH ni por HTTPS. Verificá tu acceso a github.com/widergy."; exit 1; }

-include $(MK_DIR)/mk/$(strip $(MK_TYPE)).mk

# Targets propios del repo van debajo de esta línea.
