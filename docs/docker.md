## Docker

Two separate uses, not to be mixed up:

- **[docker-compose.yml](../docker-compose.yml)** runs the app with Postgres and Redis so
  you can develop without installing anything on your machine.
- **[Dockerfile](../Dockerfile)** builds the production image that CI pushes to ECR. It is
  the same image that runs on the clusters.

### Running locally

You need a Docker with BuildKit. On macOS either
[Docker Desktop](https://www.docker.com/products/docker-desktop/) or, if you prefer a
CLI-only setup, [colima](https://github.com/abiosoft/colima):

```bash
  brew install colima docker docker-buildx docker-compose
  colima start --cpu 4 --memory 6
```

Then, from the repo root:

```bash
  docker compose up
```

The first run builds the image, which takes a few minutes. The services declare
`healthcheck`s, so `web` waits for Postgres and Redis to be ready before booting.

The app listens on `http://localhost:3000`, the admin on `http://localhost:3000/admin`.

### Setting up the database

In another console, with the stack up:

```bash
  docker compose run --rm web rails db:create db:schema:load
  docker compose run --rm web rails db:seed
```

### Useful commands

```bash
  docker compose ps                      # what is running
  docker compose logs -f web             # follow the app logs
  docker compose run --rm web bash       # a shell inside the container
  docker compose run --rm web rspec      # the suite
  docker compose stop                    # stop without deleting anything
  docker compose down -v                 # stop and drop the volumes (database included)
```

The code is mounted as a volume, so changes show up without rebuilding. You do need to
rebuild when the `Gemfile` or the `Dockerfile` change:

```bash
  docker compose build
```

### Building the production image

This is what the `build-docker-image-arch` CI job does:

```bash
  docker buildx build --secret id=ca_token,env=CA_TOKEN -t rails-api-bootstrap .
```

The `--secret` passes the AWS CodeArtifact token used to install internal gems. In this
template it is **not required**: there is no `@widergy` gem yet, so the build works
without it. It becomes necessary as soon as the repo using the template adds one.

The build has two stages. The first installs the gems and precompiles the ActiveAdmin
and PgHero assets; the second keeps only `libpq5` and `ca-certificates`, and copies the
bundle and the already-compiled app. The resulting image is around 570 MB.

It defaults to `RAILS_ENV=production`, without the development and test gems. Compose
passes `RAILS_ENV=development` as a build arg so that it does install them, because
`config/environments/development.rb` uses `listen` and the specs need rspec and
factory_bot.

### If the app needs more

| what you add | what to change |
|---|---|
| npm packages | `nodejs`, `npm` and `yarn` in the build stage, plus the `.npmrc` block with the CodeArtifact token |
| PDF generation (Grover, Puppeteer) | `chromium` in the final stage and the `PUPPETEER_EXECUTABLE_PATH` and `PUPPETEER_SKIP_CHROMIUM_DOWNLOAD` variables |
| `@widergy` gems | nothing in the Dockerfile: the secret is already wired, it just becomes required |

Any new file that should not end up in the image goes to
[.dockerignore](../.dockerignore). Without it, `COPY . .` would copy the whole working
tree, including any `.env`, which would be baked into a layer and shipped to the registry.
