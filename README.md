## About

The source code for [r.uby.dev](https://r.uby.dev). This project
provides mruby-focused services that scripts can easily interact with.

## Usage

### CLI

Serves `public/` locally.

    $ ./bin/r.uby.dev web
    $ fetch 'http://localhost:9292/'

### API Endpoints

| Endpoint | Description |
|---|---|
| `GET /mruby/search?q=QUERY` | Search the mruby source tree with `rg -F QUERY` |

## License

0BSD. See [LICENSE](./LICENSE).
