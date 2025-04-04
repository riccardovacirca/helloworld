/* *****************************************************************************
 * Copyright (C) 2023-2025  Riccardo Vacirca
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
 * ****************************************************************************/

#include "microservice.h"

extern "C" int HelloWorldRequestHandler(m_service_t *s) {
  apr_pool_t *mp = m_service_pool(s, 0);
  m_str_t *msg = m_str(mp, "Hello, World!!!", 15);
  m_http_response_header_set(s, "Content-Type", "text/plain");
  m_http_response_buffer_set(s, msg, m_slen(msg));
  return 200;
}

extern "C" int JWTAuthMiddleware(m_service_t *s) {
  return 1;
}

extern "C" void m_middlewares(m_service_t *s) {
  m_middleware(s, M_HTTP_GET, "/api", JWTAuthMiddleware);
}

extern "C" void m_routes(m_service_t *s) {
  m_route(s, M_HTTP_GET, "/api/helloworld", HelloWorldRequestHandler);
}
