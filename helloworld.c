/* Copyright (C) 2023-2025  Riccardo Vacirca
 * All rights reserved
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see
 * <https://www.gnu.org/licenses/>.
*/

#include "stdio.h"

#include "apr.h"
#include "apr_pools.h"
#include "apr_strings.h"
#include "apr_tables.h"
#include "apr_hash.h"
#include "microtools.h"
#include "microservice.h"

void ping(apr_pool_t *mp, m_str_t *prm, m_str_t **res) {
  *res = m_str(mp, "pong!!!", 7);
}

void m_rpc_register(m_server_t *srv) {
  m_rpc_bind(srv, "ping", ping);
}

int PingRPC_Stub(m_service_t *svc, const char *uri) {
  return m_rpc_send(svc, uri, "pong", "{\"id\":1001,\"method\":\"ping\",\"params\":[\"hello\",2.1,3,false]}");
}

void m_router_rpc(m_service_t *svc) {
  m_route_rpc(svc, M_HTTP_GET, "/api/ping", "ws://localhost:2380/ws", PingRPC_Stub);
}

int PingRequestHandler(m_service_t *svc) {
  m_str_t *msg = (m_str_t*)apr_hash_get(svc->request->rpc_args, "pong", APR_HASH_KEY_STRING);
  m_response_header_set(svc, "Content-Type", "text/plain");
  m_response_buffer_set(svc, msg, msg->len);
  return 200;
}

void m_router_http(m_service_t *svc) {
  m_route_http(svc, M_HTTP_GET, "/api/ping", PingRequestHandler);
}
