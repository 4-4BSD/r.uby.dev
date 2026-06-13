## About

The source code for [r.uby.dev](https://r.uby.dev). This project
provides Ruby documentation services that scripts can easily
interact with.

## Usage

### CLI

Serves `public/` locally.

    $ ./bin/r.uby.dev web
    $ fetch 'http://localhost:9292/'

### API Endpoints

| Endpoint | Description |
|---|---|
| `GET /ri/index` | List available `ri` documentation entries |
| `GET /ri/search?q=QUERY` | Render a documentation entry through `ri -T -f markdown QUERY` |

## License

0BSD. See [LICENSE](./LICENSE).
