
GRANT CONNECT ON DATABASE smi_aminiasdimor TO smi_user; 

GRANT USAGE ON SCHEMA public TO smi_user;
GRANT USAGE ON SCHEMA iglesias TO smi_user;
GRANT USAGE ON SCHEMA seguridad TO smi_user;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO smi_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA iglesias TO smi_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA seguridad TO smi_user;


-- GRANT ALL PRIVILEGES ON DATABASE smi_aminiasdimor TO smi_user; -- no funciono

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO smi_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA iglesias TO smi_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA seguridad TO smi_user;


-- referencia: https://www.it-swarm-es.com/es/postgresql/dar-todos-los-permisos-un-usuario-en-una-base-de-datos/1044566155/