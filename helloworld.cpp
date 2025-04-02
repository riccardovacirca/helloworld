
#include "microservice.h"

extern "C" int HelloWorldRequestHandler(m_service_t *s) {
  apr_pool_t *mp = m_service_pool(s, 0);
  m_str_t *msg = m_str(mp, "Hello, World!!!", 15);
  m_http_response_header_set(s, "Content-Type", "text/plain");
  m_http_response_buffer_set(s, msg, m_slen(msg));
  return 200;
}

extern "C" void m_routes(m_service_t *s) {
  m_route(s, "GET", "/api/helloworld", HelloWorldRequestHandler);
}
