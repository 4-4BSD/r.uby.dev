## About

The source code for [r.uby.dev](https://r.uby.dev). This project
provides mruby-focused guide, source, and mrbgem services that scripts
can easily interact with.

## Usage

### CLI

Serves `public/` locally.

    $ ./bin/r.uby.dev web
    $ fetch 'http://localhost:9292/'

### API Endpoints

| Endpoint | Description |
|---|---|
| `GET /api/guides/index` | List mruby guide documents |
| `GET /api/guides/search?q=QUERY` | Search mruby guides with `rg -F QUERY` |
| `GET /api/guides/read?q=PATH` | Read an mruby guide document |
| `GET /api/mruby/index` | List files in the configured mruby source tree |
| `GET /api/mruby/search?q=QUERY` | Search the mruby source tree with `rg -F QUERY` |
| `GET /api/mruby/read?q=PATH` | Read a file from the mruby source tree |
| `GET /api/mrbgems/index` | List known mrbgem metadata files |
| `GET /api/mrbgems/search?q=QUERY` | Search known mrbgems by name |
| `GET /api/mrbgems/read?q=GEM` | Read metadata for a known mrbgem |

## License

0BSD. See [LICENSE](./LICENSE).
