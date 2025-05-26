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
CXX:=clang++
CFLAGS:=-std=gnu11 -g -DM_DEBUG -DMG_ENABLE_PACKED_FS=1 -DM_FS
CXXFLAGS:=-std=c++11 -g -DM_DEBUG
INCLUDES:=-I. -I./mongoose -I./microservice -I./microservice/microtools -I./unity -I/usr/include -I/usr/include/apr-1.0
LDFLAGS:=-lapr-1 -laprutil-1

NAME:=helloworld
OBJS:=mongoose.o fs.o $(NAME).o microservice.o

all: $(NAME)
	@$(MAKE) -s clean

$(NAME): $(OBJS)
	@mkdir -p bin
	$(CXX) -o bin/$(NAME) $(OBJS) -L./microtools -lmicrotools $(LDFLAGS) -lstdc++

mongoose.o: mongoose.c
	$(CC) $(CFLAGS) $(INCLUDES) -c mongoose/$< -o $@

$(NAME).o: $(NAME).cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

microservice.o: microservice.c
	$(CC) $(CFLAGS) $(INCLUDES) -c microservice/$< -o $@

fs.o: fs.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

fs.c:
	mkdir -p ./bin && rm -rf /tmp/fs && mkdir -p /tmp/fs; \
	gzip -c /$(NAME)/microtools/microtools.js > /tmp/fs/microtools.js.gz; \
	gzip -c /$(NAME)/microtools/microtools.css > /tmp/fs/microtools.css.gz; \
	gzip -c /$(NAME)/index.html > /tmp/fs/index.html.gz; \
	clang -o /$(NAME)/bin/pack /$(NAME)/mongoose/test/pack.c && \
	cd /tmp && /$(NAME)/bin/pack fs/* > /$(NAME)/fs.c && \
	rm -rf fs && cd /$(NAME) && rm /$(NAME)/bin/pack

run:
	LD_LIBRARY_PATH=./microtools:$LD_LIBRARY_PATH \
	bin/$(NAME) -h "0.0.0.0" -p "2310" -w "2380" -r "1000" -t "1000" -T 10 \
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
