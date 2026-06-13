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
| `GET /mruby/src/index` | List files in the configured mruby source tree |
| `GET /mruby/src/search?q=QUERY` | Search the mruby source tree with `rg -F QUERY` |
| `GET /mruby/src/read?q=PATH` | Read a file from the mruby source tree |
| `GET /mruby/mrbgems/index` | List known mrbgem manifests |
| `GET /mruby/mrbgems/search?q=QUERY` | Search known mrbgem manifest filenames |
| `GET /mruby/mrbgems/read?q=GEM` | Read a known mrbgem manifest |

## License

0BSD. See [LICENSE](./LICENSE).
