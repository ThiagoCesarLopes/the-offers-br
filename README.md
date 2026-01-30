# TheOffersBR - Phoenix LiveView Edition

A complete migration of the earn-watch-shop affiliate platform from React SPA to Phoenix LiveView with PostgreSQL backend.

## Project Structure

```
theoffersbr/
├── lib/
│   ├── theoffersbr/               # Core business logic (contexts)
│   │   ├── catalog.ex             # Product & offer management
│   │   ├── accounts.ex            # User & profile management
│   │   ├── analytics.ex           # Click & conversion tracking
│   │   ├── integrations.ex        # Third-party integrations (Mercado Livre)
│   │   ├── catalog/               # Catalog domain schemas
│   │   │   ├── category.ex        # Product categories
│   │   │   ├── store.ex           # Affiliate stores (Amazon, Shopee, etc.)
│   │   │   ├── offer.ex           # Product offers with pricing
│   │   │   ├── favorite.ex        # User favorites
│   │   │   ├── offer_click.ex     # Click tracking with conversions
│   │   │   └── sync_log.ex        # Background job history
│   │   ├── accounts/              # Accounts domain schemas
│   │   │   ├── profile.ex         # User profiles with PIX payment info
│   │   │   ├── profile_type.ex    # Admin/Associado/Cliente roles
│   │   │   ├── user_role.ex       # RBAC
│   │   │   └── associate_social_account.ex # Social media accounts
│   │   └── integrations/          # Integration schemas
│   │       ├── ml_integration.ex  # Mercado Livre API config
│   │       └── ml_offer_mapping.ex # ML sync status
│   └── theoffersbr_web/           # Web interface (LiveView)
│       ├── live/
│       │   ├── index_live.ex      # Home page - category & offer listing
│       │   ├── auth_live.ex       # Authentication flow
│       │   ├── admin/             # Admin dashboard (9 pages)
│       │   │   ├── dashboard_live.ex      # KPI overview
│       │   │   ├── ofertas_live.ex        # Offer management
│       │   │   ├── cliques_live.ex        # Click analytics
│       │   │   ├── categorias_live.ex     # Category management
│       │   │   ├── lojas_live.ex          # Store listing
│       │   │   ├── mercado_livre_live.ex  # ML integrations
│       │   │   ├── config_live.ex         # App settings
│       │   │   ├── users_live.ex          # User profiles
│       │   │   ├── profile_live.ex        # Admin profile
│       │   │   └── associates_financial_live.ex # Commission tracking
│       │   └── associate/         # Affiliate dashboard (4 pages)
│       │       ├── dashboard_live.ex  # Affiliate overview
│       │       ├── offers_live.ex     # Active offers for promotion
│       │       ├── social_accounts_live.ex # Social media management
│       │       └── settings_live.ex   # Affiliate settings
│       └── router.ex              # Route definitions (23 routes)
├── priv/
│   └── repo/
│       └── migrations/            # Supabase schema migrations (27 files)
├── docs/
│   ├── SUPABASE_ERD.md           # Entity relationship diagram
│   └── SUPABASE_ERD.mmd          # Mermaid format diagram
├── config/
│   ├── config.exs                # App configuration
│   ├── dev.exs                   # Development settings
│   ├── prod.exs                  # Production settings
│   └── test.exs                  # Test settings
├── docker-compose.yml            # PostgreSQL 16 container
└── mix.exs                        # Project dependencies

```

## Database Schema

The application uses PostgreSQL 16 with 13 main tables:

**Catalog Domain:**
- `categories` - Product categories (8 seeded: Eletrônicos, Casa, Moda, etc.)
- `stores` - Affiliate stores (Amazon, Shopee, Mercado Livre, Magazine Luiza)
- `offers` - Product offers with pricing, commissions, and affiliate links
- `favorites` - User favorite offers (tracking)
- `offer_clicks` - Click tracking with conversion data
- `sync_logs` - Background job execution history

**Accounts Domain:**
- `profiles` - User profiles with PIX payment information
- `profile_types` - Role taxonomy (Admin, Associado, Cliente)
- `user_roles` - RBAC assignments
- `associate_social_accounts` - Social media accounts for affiliates

**Integrations Domain:**
- `ml_integrations` - Mercado Livre API credentials
- `ml_offer_mappings` - ML offer sync status

**Auth Domain (mocked locally):**
- `auth.users` - Supabase-style authentication

See [docs/SUPABASE_ERD.md](docs/SUPABASE_ERD.md) for full ERD.

## Getting Started

### Prerequisites
- Elixir 1.19.5+
- Erlang/OTP 27+
- Docker & Docker Compose
- PostgreSQL 16 (via Docker)

### Setup

1. **Start PostgreSQL:**
   ```bash
   docker compose up -d
   ```

2. **Install dependencies:**
   ```bash
   mix setup
   ```
   This will:
   - Install Elixir dependencies
   - Create the database
   - Run all 27 migrations
   - Apply Supabase compatibility fixes

3. **Start the server:**
   ```bash
   mix phx.server
   ```

4. **Access the application:**
   - **Home:** http://localhost:4000
   - **Admin Dashboard:** http://localhost:4000/admin/dashboard
   - **Associate Dashboard:** http://localhost:4000/associado/dashboard

## Features Implemented

✅ **Database Layer:**
- 13 PostgreSQL tables with proper relationships and constraints
- 27 migrations fully applied from Supabase schema
- Ecto schemas with changesets and validations
- Context modules for business logic organization

✅ **Web Layer:**
- 13 LiveView pages (public, admin, associate)
- Hot reload development environment
- Tailwind CSS 4.1.12 with DaisyUI components
- 23 routes with proper scoping

✅ **Features:**
- Category listing and filtering
- Offer display with pricing and commissions
- User profile management
- Admin dashboard with KPIs
- Associate profile pages
- Click tracking foundation (database ready)

## Pending Features

⏳ **Authentication:**
- Real Supabase integration
- User registration & login flows
- Session management

⏳ **Affiliate System:**
- Redirect tracking endpoint (`/r/:offer_id`)
- Commission calculation
- Social account linking with follower tracking

⏳ **Admin Features:**
- Offer CRUD operations (create/update/delete)
- Category management forms
- Store management interface

⏳ **Integrations:**
- Mercado Livre API OAuth flow
- Automatic product sync
- Offer mapping management

## Architecture

### Technology Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| **Runtime** | Elixir | 1.19.5 |
| **Framework** | Phoenix | 1.8.3 |
| **Real-time** | Phoenix LiveView | 1.1.22 |
| **ORM** | Ecto | 3.13.5 |
| **Database** | PostgreSQL | 16 |
| **Web Server** | Bandit | 1.10.2 |
| **Styling** | Tailwind CSS | 4.1.12 |
| **Components** | DaisyUI | 5.0.35 |

### Directory Organization

Code is organized into **business domain contexts**:
- `Theoffersbr.Catalog` - Products, categories, offers, clicks
- `Theoffersbr.Accounts` - Users, profiles, roles
- `Theoffersbr.Analytics` - Click analytics
- `Theoffersbr.Integrations` - Third-party APIs

Each context has:
- Module file: `lib/theoffersbr/context.ex` with public functions
- Schemas: `lib/theoffersbr/context/*.ex` for each entity
- Web layer: `lib/theoffersbr_web/live/*` for LiveView components

## Configuration

### Environment Variables

`config/dev.exs` automatically uses:
```
POSTGRES_USER=postgres        # Default: postgres
POSTGRES_PASSWORD=postgres    # Default: postgres
POSTGRES_HOST=localhost       # Default: localhost
POSTGRES_DB=theoffersbr_dev   # Default: theoffersbr_dev
POSTGRES_PORT=5432           # Default: 5432
```

### Disabling Symlink Warning

If running on Windows without admin terminal, disable the symlink warning in `config/dev.exs`:
```elixir
config :phoenix_live_view, :colocated_js,
  disable_symlink_warning: true
```

## Development Commands

```bash
# Start development server (auto hot reload)
mix phx.server

# Run tests
mix test

# Database commands
mix ecto.create        # Create database
mix ecto.migrate       # Run migrations
mix ecto.rollback      # Rollback last migration

# Interactive Elixir shell
iex -S mix phx.server

# Code formatting
mix format
```

## Deployment

For production deployment, see [Phoenix Deployment Guides](https://hexdocs.pm/phoenix/deployment.html).

Key considerations:
- Build static assets: `mix phx.digest`
- Set environment variables for production database
- Configure CORS and security headers
- Set up reverse proxy (Nginx recommended)

## Learn More

* [Phoenix Framework Documentation](https://hexdocs.pm/phoenix)
* [Ecto Documentation](https://hexdocs.pm/ecto)
* [Phoenix LiveView Guide](https://hexdocs.pm/phoenix_live_view)
* [Elixir Language Guide](https://elixir-lang.org/getting-started/introduction.html)

## Project Status

**Migration Phase:** ✅ Complete
- Database schema fully migrated from Supabase
- Ecto models and contexts implemented
- LiveView pages created for all major features
- Development server operational with hot reload

**Next Phase:** Authentication & Affiliate Features
- Real user authentication
- Click tracking and commission system
- Social account integration

## Support

For issues or questions about this Phoenix LiveView implementation, refer to the Elixir and Phoenix communities at https://elixirforum.com
