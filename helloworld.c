
/* Copyright (C) 2023-2025  Riccardo Vacirca
 * All rights reserved
*/

#include "stdio.h"
#include "microservice.h"

void ping(apr_pool_t *mp, m_str_t *prm, m_str_t **res) {
  *res = m_str(mp, "\"pong!!!\"", 9);
}

void m_mg_rpc_register(m_mg_server_t *srv) {
  m_mg_rpc_bind(srv, "ping", ping);
}

int PingRPC_Stub(m_mg_service_t *svc, const char *uri) {
  return m_mg_rpc_send(svc, uri, "pong", "{\"id\":1001,\"method\":\"ping\",\"params\":[\"hello\",2.1,3,false]}");
}

void m_router_rpc(m_mg_service_t *svc) {
  m_mg_route_rpc(svc, M_HTTP_GET, "/api/ping", "ws://localhost:2791/ws", PingRPC_Stub);
}

int PingRequestHandler(m_mg_service_t *svc) {
  m_str_t *msg = (m_str_t*)apr_hash_get(svc->request->rpc, "pong", APR_HASH_KEY_STRING);
  m_mg_response_header_set(svc, "Content-Type", "text/plain");
  m_mg_response_buffer_set(svc, msg->buf, msg->len);
  return 200;
}

int PostRequestHandler(m_mg_service_t *svc) {
  m_str_t *msg = m_str(svc->pool, "HELLO", 5);
  
  if (svc->request->parsed_body) {
    apr_hash_t *args = (apr_hash_t*)svc->request->parsed_body;
    //m_str_t *title = (m_str_t*)apr_hash_get(args, "title", APR_HASH_KEY_STRING);
    const char* title = (const char*)apr_hash_get(args, "title", APR_HASH_KEY_STRING);
    if (title) {
      printf("\n\nTITLE: %s\n\n", title);
    }
  }
  m_mg_response_header_set(svc, "Content-Type", "text/plain");
  m_mg_response_buffer_set(svc, msg->buf, msg->len);
  return 200;
}

void m_mg_router_http(m_mg_service_t *svc) {
  m_mg_route_http(svc, M_HTTP_GET, "/api/ping", PingRequestHandler);
  m_mg_route_http(svc, M_HTTP_POST, "/api/post_rq", PostRequestHandler);
}
