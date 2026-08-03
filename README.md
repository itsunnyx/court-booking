# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Keycloak for local development

Start Keycloak and its PostgreSQL database:

```sh
docker compose up -d keycloak
```

Open the Admin Console at <http://localhost:8080>. The local defaults are
`admin`/`admin`. Override all development credentials when needed:

```sh
KEYCLOAK_ADMIN_USERNAME=admin \
KEYCLOAK_ADMIN_PASSWORD=change-me \
KEYCLOAK_DB_PASSWORD=change-me \
docker compose up -d keycloak
```

The Compose service uses Keycloak's `start-dev` mode and must not be used as a
production deployment configuration.
