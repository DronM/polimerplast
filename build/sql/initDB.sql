CREATE USER polimerplast WITH PASSWORD '159753';
CREATE DATABASE polimerplast;
GRANT ALL PRIVILEGES ON DATABASE polimerplast TO polimerplast;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO polimerplast;