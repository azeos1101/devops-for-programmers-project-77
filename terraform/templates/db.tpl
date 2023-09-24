#!/bin/bash
echo 'DB_TYPE="${db_type}"' >> /etc/environment
echo 'DB_NAME="${database}"' >> /etc/environment
echo 'DB_HOST="${host}"' >> /etc/environment
echo 'DB_PORT=${port}' >> /etc/environment
echo 'DB_USER="${user}"' >> /etc/environment
echo 'DB_PASS="${password}"' >> /etc/environment
