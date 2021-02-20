#include "stdio.h"
#include "stdlib.h"
#include "apr.h"
#include "apr_pools.h"

int main(){
	apr_status_t rv;
	apr_pool_t * mp;

	rv = apr_initialize();
	if (rv != APR_SUCCESS) exit(EXIT_FAILURE);
	rv = apr_pool_create(&mp, NULL);
	if (rv != APR_SUCCESS) exit(EXIT_FAILURE);


	printf("Hello\n");


	apr_pool_destroy(mp);
	apr_terminate();
	return 0;
}
