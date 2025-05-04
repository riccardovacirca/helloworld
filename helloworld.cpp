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
#include "microservice.h"
#include "json-c/json.h"

extern "C" int m_rpc_stub_sum(m_service_t *svc, const char *uri)
{ char rpc_message[] = "{\"id\":1002,\"method\":\"sum\",\"params\":[2,4]}";
  return m_rpc_send(svc, uri, "sum_result", rpc_message);
}

extern "C" int GetStatusRequestHandler(m_service_t *svc) {
  apr_pool_t *mp = m_service_pool_get(svc);
  if (!mp) {
    return 500;
  }
  m_str_t *sum_res = m_service_req_extra_get(svc, "sum_result");
  if (sum_res) {
    printf("SUM++: %s\n", m_sbuf(sum_res));
  }
  struct json_object *jobj = json_object_new_object();
  const char *message = "It Works!!!";
  json_object_object_add(jobj, "message", json_object_new_string(message));
  const char *json_string = json_object_to_json_string(jobj);
  char *res = apr_psprintf(mp, M_SUCCESS_FMT, json_string);
  m_str_t *msg = m_str(mp, res, strlen(res));
  if (!msg) {
    return 500;
  }
  m_response_header_set(svc, "Content-Type", "application/json");
  m_response_buffer_set(svc, msg, m_slen(msg));
  m_response_type_set(svc, M_RESPONE_TP_STRING);
  json_object_put(jobj);
  return 200;
}

extern "C" void m_rpc_routes(m_service_t *svc, void *ctx)
{ m_rpc_route(svc, ctx, M_HTTP_GET, "/api/status", "ws://localhost:2380/ws", m_rpc_stub_sum);
}

extern "C" void m_routes(m_service_t *svc)
{ m_route(svc, M_HTTP_GET, "/api/status", GetStatusRequestHandler);
}
