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
#include "stdio.h"
#include "apr_hash.h"

extern "C" int JWTAuthMiddleware(m_service_t *s) {
  return 1;
}

extern "C" void GetUser(m_service_t *svc) {
  apr_pool_t *mp = m_service_pool(svc);
  apr_hash_t *data = apr_hash_make(mp);
  m_str_t *user_id = m_service_request_get(svc, "user_id");
  apr_hash_set(data, "id", APR_HASH_KEY_STRING, user_id);
  int rv = m_ws_get(svc, svc->ws_conn, "GetUserById", &data);
}

extern "C" int HelloWorldRequestHandler(m_service_t *s) {
  apr_pool_t *mp = m_service_pool(s, 0);
  m_str_t *msg = m_str(mp, "Hello, World!!!", 15);
  m_http_response_header_set(s, "Content-Type", "text/plain");
  m_http_response_buffer_set(s, msg, m_slen(msg));
  return 200;
}

extern "C" void m_middlewares(m_service_t *s) {
  m_middleware(s, M_HTTP_GET, "/api/", 5, JWTAuthMiddleware);
}


// m_ws_services esegue ogni m_ws_service definita con i relativi parametri.
// viene eseguita 2 volte.
// ogni funzione m_ws_service invocata viene eseguita 2 volte
extern "C" void m_ws_routes(m_service_t *svc) {
  // Prima esecuzione:
  //    - Apre una connessione verso ws://192.168.1.10:8090
  //    - Crea un identificativo univoco per una connessione ws
  //      usando una combinazione di metodo e url come chiave
  //    - Associa la connessione all'identificativo univoco in una hashtable
  // Seconda esecuzione:
  //    - m_ws_service viene eseguita nel request handler prima di lanciare
  //      il thread separato, dopo che è stato terminato il parsing dei
  //      parametri della request
  //    - Genera la chiave usando una combinazione di metodo e url
  //    - Prova ad estrarre dalla hashtable la connessione associata alla chiave
  //    - Se esiste setta la connessione nella struct m_service_t e invoca
  //      la funzione utente (es. GetUser) passandole m_service_t
  m_ws_route(svc, M_HTTP_GET, "/api/helloworld", "ws://192.168.1.10:8090", GetUser);
}

extern "C" void m_routes(m_service_t *s) {
  m_route(s, M_HTTP_GET, "/api/helloworld", HelloWorldRequestHandler);
}
