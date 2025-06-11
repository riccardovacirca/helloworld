
/* Copyright (C) 2023-2025  Riccardo Vacirca
 * All rights reserved
*/

#include "stdio.h"
#include "microservice.h"

int HelloWorld(m_mg_service_t *svc) {
  m_str_t *msg = m_str(svc->pool, "Hello, World!", 16);
  const char *buf;
  apr_size_t len = m_str_to_json(svc->pool, msg, &buf);
  m_mg_response_header_set(svc, "Content-Type", "application/json");
  m_mg_response_buffer_set(svc, (void*)buf, len);
  return 200;
}

void m_mg_router_http(m_mg_service_t *svc) {
  m_mg_route_http(svc, M_HTTP_GET, "/api/helloworld", HelloWorld);
}
