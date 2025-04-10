# ##############################################################################
# Copyright (C) 2023-2025  Riccardo Vacirca
# All rights reserved
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see
# <https://www.gnu.org/licenses/>.
# ##############################################################################

CC:=clang
CXX:=clang++
CFLAGS:=-std=gnu11 -g -DM_DEBUG -DMG_ENABLE_PACKED_FS=1 -DM_FS
CXXFLAGS:=-std=c++11 -g -DM_DEBUG
INCLUDES:=-I. -I./mongoose -I./microservice -I./unity -I./cppjwt \
	-I/usr/include -I/usr/include/apr-1.0
LIBS:=
LDFLAGS:=-lapr-1 -laprutil-1 -ljson-c
SRC:=mongoose.o fs.o microservice.o
NAME:=helloworld

all: $(SRC)
	@mkdir -p bin
	$(CXX) -o bin/$(NAME) $^ $(LDFLAGS) -lstdc++
	@$(MAKE) -s clean

mongoose.o: mongoose.c
	$(CC) $(CFLAGS) $(INCLUDES) -c mongoose/$< -o $@

$(NAME).o: $(NAME).cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

microservice.o: microservice.c
	$(CC) $(CFLAGS) $(INCLUDES) -c microservice/$< -o $@

fs.o: fs.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

run:
	@bin/$(NAME) -h "0.0.0.0" -p "2310" -w "2380" -r "1000" \
	-l "/var/log/$(NAME).log" -s 10 -d "mysql" \
	-D "host=mariadb,port=3306,user=$(NAME),pass=secret,dbname=$(NAME)"

debug:
	gdb bin/$(NAME) core

clean:
	@rm -rf *.o

clean-all: clean
	@rm -rf bin/$(NAME) core

webroot:
	mkdir -p webroot
	curl -fsSL https://deb.nodesource.com/setup_current.x | bash -
	apt-get install -y nodejs
	npm create vite webroot --template svelte
	@echo "import { defineConfig } from 'vite'" > webroot/vite.config.ts
	@echo "import { svelte } from '@sveltejs/vite-plugin-svelte'" >> webroot/vite.config.ts
	@echo "export default defineConfig({" >> webroot/vite.config.ts
	@echo "  plugins: [svelte()]," >> webroot/vite.config.ts
	@echo "  build: {" >> webroot/vite.config.ts
	@echo "    outDir: './dist'," >> webroot/vite.config.ts
	@echo "    emptyOutDir: true," >> webroot/vite.config.ts
	@echo "    assetsDir: './'" >> webroot/vite.config.ts
	@echo "  }," >> webroot/vite.config.ts
	@echo "  server: {" >> webroot/vite.config.ts
	@echo "    host: '0.0.0.0'," >> webroot/vite.config.ts
	@echo "    port: $(WEB_PORT)" >> webroot/vite.config.ts
	@echo "  }" >> webroot/vite.config.ts
	@echo "})" >> webroot/vite.config.ts

webroot-pack:
	@if [ -d "webroot/dist" ]; then \
		if [ ! -f "webroot/.disabled" ]; then \
			mkdir -p ./bin && rm -rf /tmp/fs && mkdir -p /tmp/fs; \
			FS_FILES=$$(find webroot/dist -type f); \
			for file in $$FS_FILES; do \
				dir_structure=$$(dirname "$$file" | sed 's|webroot/dist|/tmp/fs|'); \
				mkdir -p "$$dir_structure"; \
				gzip -c "$$file" > "$$dir_structure/$$(basename "$$file").gz"; \
			done; \
			clang -o /$(NAME)/bin/pack /$(NAME)/mongoose/test/pack.c && \
			cd /tmp && /$(NAME)/bin/pack fs/* > /$(NAME)/fs.c && \
			rm -rf fs && cd /$(NAME) && rm /$(NAME)/bin/pack; \
		fi; \
	fi

.PHONY: all mongoose.o mongoose.c $(NAME).o $(NAME).c \
				microservice.o microservice.c fs.o fs.c run debug clean clean-all \
				webroot webroot-pack
