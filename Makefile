# ##############################################################################
#
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
# 
# ##############################################################################

CC:=clang
CXX:=clang++
CFLAGS:=-std=gnu11 -g -DM_DEBUG
CXXFLAGS:=-std=c++11 -g -DM_DEBUG
INCLUDES:=-I. -I/usr/include -I/usr/include/apr-1.0
LIBS:=
LDFLAGS:=-lapr-1 -laprutil-1

all: mongoose.o service.o microservice.o
	@mkdir -p bin
	$(CXX) -o bin/service $^ $(LDFLAGS) -lstdc++
	@$(MAKE) -s clean

mongoose.o: mongoose.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

service.o: service.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

microservice.o: microservice.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

run:
	@bin/service -h "0.0.0.0" -p "2310" -w "2320" -r "1000" \
	-l "/var/log/service.log" -s 10 -d "mysql" \
	-D "host=mariadb,port=3306,user=helloworld,pass=secret,dbname=helloworld"

debug:
	gdb bin/service core

clean:
	@rm -rf *.o

clean-all: clean
	@rm -rf bin/service core

.PHONY: all mongoose.c main.c run debug clean clean-all
