# Copyright (C) 2023-2025 Riccardo Vacirca
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

CC:=clang
CFLAGS:=-std=gnu11 -g -DM_DEBUG -DMG_ENABLE_PACKED_FS=1 -DM_FS -DMICROTOOLS
INCLUDES:=-I. -I./mongoose -I./microservice -I./microtools -I./unity \
	-I/usr/include -I/usr/include/apr-1.0
LIBS:=-L/helloworld/microtools
LDFLAGS:=-lmicrotools -lapr-1 -laprutil-1 -Wl,-rpath,/helloworld/microtools \
	-Wl,--export-dynamic -Wl,-z,lazy

NAME:=helloworld
OBJS:=mongoose.o fs.o $(NAME).o microservice.o

all: $(NAME)
	@$(MAKE) -s clean

$(NAME): $(OBJS)
	@mkdir -p bin
	$(CC) -o bin/$(NAME) $(OBJS) $(LIBS) $(LDFLAGS)

mongoose.o: mongoose.c
	$(CC) $(CFLAGS) $(INCLUDES) -c mongoose/$< -o $@

$(NAME).o: $(NAME).c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

microservice.o: microservice.c
	$(CC) $(CFLAGS) $(INCLUDES) -c microservice/$< -o $@

fs.o: fs.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

fs.c:
	mkdir -p ./bin && rm -rf /tmp/fs && mkdir -p /tmp/fs; \
	gzip -c /$(NAME)/microtools/microtools.js > /tmp/fs/microtools.js.gz; \
	gzip -c /$(NAME)/microtools/microtools.css > /tmp/fs/microtools.css.gz; \
	gzip -c /$(NAME)/test.html > /tmp/fs/test.html.gz; \
	clang -o /$(NAME)/bin/pack /$(NAME)/mongoose/test/pack.c && \
	cd /tmp && /$(NAME)/bin/pack fs/* > /$(NAME)/fs.c && \
	rm -rf fs && cd /$(NAME) && rm /$(NAME)/bin/pack

run:
	LD_LIBRARY_PATH=/helloworld/microtools:$LD_LIBRARY_PATH \
	bin/$(NAME) -h "0.0.0.0" -p "2310" -w "2791" -r "500" -t "100" -T 10 \
	-l "/var/log/$(NAME).log" -s 10 -d "mysql" \
	-D "host=mariadb,port=3306,user=$(NAME),pass=$(NAME),dbname=$(NAME)"

debug:
	gdb bin/$(NAME) core

clean:
	@rm -rf *.o

clean-all: clean
	@rm -rf bin/$(NAME) core

.PHONY: all mongoose.o mongoose.c $(NAME).o $(NAME).c \
				microservice.o microservice.c fs.o fs.c run debug clean clean-all
