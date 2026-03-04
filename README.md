# Rails Technical Environment

A Dockerized Ruby on Rails environment.

# Search Pokemon

The app has a search feature that allows users to search for Pokemon by name.

The search is implemented in the `Pokemon` model using the `search` concern.

The search is case-insensitive and prioritizes the local database. If a match is not found locally, it is fetched from an external API and persisted for future use.

If no match is found in either the database or the API, an error message is returned.

example:

## Success case
```ruby
Pokemon.search("pikachu")

# output:  #<Pokemon id: 1, name: "pikachu", weight: 60, height: 4, created_at: "2026-03-04 20:46:41", updated_at: "2026-03-04 20:46:41">
```
## Error case
```ruby
Pokemon.search("Pikache")

# output:  Error: Pokemon pikache not found
```


## Stack

| Component | Version |
|-----------|---------|
| Ruby | 2.7.8 |
| Rails | ~> 5.2.2.1 |
| PostgreSQL | 14 |
| Redis | 7 |
| Sidekiq | latest |
| RSpec | 5.1.2 |
| Rubocop | 1.33.0 |

---

## 📦 Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Make](https://www.gnu.org/software/make/)

---

## 🚀 Getting Started

### One-step setup

```bash
make setup
```

This runs `build`, `up`, `db-create`, and `db-migrate` in sequence.

### Or step by step

```bash
# 1. Build the Docker images
make build

# 2. Start all containers (web, db, redis, sidekiq)
make up

# 3. Create and migrate the database
make db-create
make db-migrate
```

The Rails app will be available at **http://localhost:3000**.

---

## 🛠️ Available Commands

| Command | Description |
|---------|-------------|
| `make setup` | Full first-time setup (build + up + db-create + db-migrate) |
| `make build` | Build Docker images (no cache) |
| `make up` | Start all containers in detached mode |
| `make down` | Stop and remove containers |
| `make restart` | Restart all containers |
| `make logs` | Tail container logs |
| `make shell` | Open a bash shell in the web container |
| `make console` | Open a Rails console |
| `make bundle` | Run `bundle install` inside the container |
| `make db-create` | Create the database |
| `make db-migrate` | Run pending migrations |
| `make db-reset` | Drop, create, and migrate the database |
| `make test` | Run the full RSpec test suite |
| `make test-watch` | Run RSpec with documentation formatter |
| `make rubocop` | Run Rubocop linter |
| `make rubocop-safe-correct` | Run Rubocop with safe auto-corrections (`-a`) |
| `make rubocop-auto-correct` | Run Rubocop with all auto-corrections (`-A`) |

---

## 🐳 Services

The `docker-compose.yml` defines four services:

| Service   | Description                      | Port |
|-----------|----------------------------------|------|
| `web`     | Rails app (Puma)                 | 3000 |
| `db`      | PostgreSQL 14                    | —    |
| `redis`   | Redis 7                          | —    |
| `sidekiq` | Sidekiq background job processor | —    |

---

## 📂 Project Structure

```
sendu_demo/
├── Dockerfile
├── docker-compose.yml
├── makefile
├── entrypoint.sh
├── Gemfile
├── Gemfile.lock
├── app/
│   ├── controllers/
│   ├── jobs/
│   ├── models/
│   └── views/
├── config/
├── db/
└── spec/
```

---

## ✅ Testing

Tests are written with **RSpec**. Run them with:

```bash
make test
```

Or with verbose output:

```bash
make test-watch
```

---

## 🎯 Interview Use Cases

This environment is ready for:

- Live coding challenges
- Technical interviews
- System design discussions
- Code reviews
- Debugging exercises
- Background job implementation with Sidekiq

---

## 📄 License

MIT License