# Default command for `make`:
.DEFAULT_GOAL := all

# Sources:
SOURCE.dir := "./src"
SOURCE.dir.favicon := "${SOURCE.dir}/favicon"
SOURCE.dir.images := "${SOURCE.dir}/images"
SOURCE.file.index.html := "./index.html"

# Destinations:
OUTPUT.dir := "."
OUTPUT.dir.img := "${OUTPUT.dir}/images"

# Misc:
MISC.server.port := 3000
MISC.timestamp := $(shell date +%Y-%m-%d\ %H:%M:%S)

# `make` commands:
.PHONY: all
all: min-html min-jsonld min-json min-xml min-img

.PHONY: clean
clean:
	@echo "[${MISC.timestamp}] INFO make clean"
	@bash ./scripts/clean ${SOURCE.dir} ${OUTPUT.dir}
	@bash ./scripts/clean ${SOURCE.dir.favicon} ${OUTPUT.dir}

.PHONY: min-html
min-html:
	@echo "[${MISC.timestamp}] INFO make min-html"
	@bash ./scripts/min-html ${SOURCE.dir} ${OUTPUT.dir}

.PHONY: min-jsonld
min-jsonld:
	@echo "[${MISC.timestamp}] INFO make min-jsonld"
	@bash ./scripts/min-jsonld ${SOURCE.file.index.html}

.PHONY: min-json
min-json:
	@echo "[${MISC.timestamp}] INFO make min-json"
	@bash ./scripts/min-json ${SOURCE.dir.favicon} ${OUTPUT.dir}

.PHONY: min-xml
min-xml:
	@echo "[${MISC.timestamp}] INFO make min-xml"
	@bash ./scripts/min-xml ${SOURCE.dir.favicon} ${OUTPUT.dir}

.PHONY: min-img
min-img:
	@echo "[${MISC.timestamp}] INFO make min-img"
	@bash ./scripts/min-img ${SOURCE.dir.favicon} ${OUTPUT.dir}
	@bash ./scripts/min-img ${SOURCE.dir.images} ${OUTPUT.dir.img}

.PHONY: dev-server
dev-server:
	@echo "[${MISC.timestamp}] INFO make dev-server"
	@xdg-open http://localhost:${MISC.server.port}
	@cd ${SOURCE.dir} && python3 -m http.server ${MISC.server.port}

.PHONY: server
server: all
	@echo "[${MISC.timestamp}] INFO make server"
	@xdg-open http://localhost:${MISC.server.port}
	@cd ${OUTPUT.dir} && python3 -m http.server ${MISC.server.port}

.PHONY: prep-docs
prep-docs:
	@echo "[${MISC.timestamp}] INFO make server"
	@cd ./docs/ && pipenv shell
