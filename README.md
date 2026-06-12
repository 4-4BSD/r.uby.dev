## About

The source code for [r.uby.dev](https://r.uby.dev). This project
provides Ruby documentation as a SQLite3 database that can be
queried with FTS through a headless web interface that scripts
can easily interact with.

## Usage

### CLI

#### create-database

Creates a new database in `share/rubydoc/database.sqlite3`

    $ rubydoc create-database

#### web

Serves a HTTP API that can query the documentation with FTS

    $ rubydoc web
    $ fetch 'http://localhost:9292/ri/search?q=Enumerable'

### API Endpoints

| Endpoint | Description |
|---|---|
| `GET /ri/search?q=QUERY` | Search Ruby documentation |
| `GET /rdoc/search?q=QUERY` | Search rdoc documentation |

## License

0BSD. See [LICENSE](./LICENSE).
