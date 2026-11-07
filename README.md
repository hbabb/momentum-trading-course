# Algorithmic Trading Recording

This repository contains a Django-based algorithmic trading prototype focused on momentum-based stock screening, portfolio tracking, and brokerage integration. The project is structured as a single Django project under the `project1/` directory and combines market data ingestion, model-based portfolio storage, and order execution hooks via external APIs.

## Overview

The application is designed to:

- collect and store historical stock price data
- calculate momentum scores against a lookback window
- rank stocks by momentum and identify top/bottom quintiles
- generate buy/sell trading signals for a portfolio
- sync positions and execute orders through SnapTrade
- track portfolio performance and rebalance events

This is primarily a research/development trading system rather than a production-ready brokerage platform.

## Project structure

```text
.
├── .gitignore
├── README.md
|
├── .env.example
├── manage.py
├── requirements.txt
├── momentum_trader/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   ├── asgi.py
│   └── wsgi.py
├── portfolio/
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── models.py
│   ├── tests.py
│   └── views.py
├── trading/
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── models.py
│   ├── tests.py
│   ├── views.py
│   ├── management/
│   │   └── commands/
│   │       └── pull_massive_data.py
│   └── services/
│       ├── massive_client.py
│       ├── momentum_calculator.py
│       ├── snaptrade_client.py
│       └── strategy_engine.py
└── db.sqlite3   # created after initial DB setup
```

## Core components

### Trading data layer

The `trading` app defines the core models used by the strategy:

- `Stock`: ticker and metadata
- `PriceData`: price history by date
- `MomentumScore`: calculated momentum values and ranking metadata
- `TradingSignal`: buy/sell/hold decisions
- `RebalanceEvent`: periodic execution summaries

### Momentum engine

The momentum logic in `trading/services/momentum_calculator.py` calculates performance using a 12-month lookback and compares it to a recent 1-month data point. It includes:

- database-first lookups
- API fallback to Massive
- bulk calculation support for many tickers
- quintile-based ranking and reporting

### Broker integration

The project integrates with SnapTrade via `trading/services/snaptrade_client.py` to:

- sync portfolio positions
- submit market orders
- update order status
- evaluate available cash for trading

### Market data access

`trading/services/massive_client.py` handles access to the Massive API and includes:

- rate limiting
- caching
- batch fetching patterns
- fallback logic for missing market data

## Tech stack

- Python
- Django 5.2
- SQLite (default database)
- Massive API for market data
- SnapTrade Python SDK
- python-decouple for environment variable loading

## Prerequisites

Before running the project, make sure you have:

- Python 3.10+ (the project references Python 3.12-era artifacts)
- pip and a virtual environment
- API credentials for:
  - Massive
  - SnapTrade

## Getting started

1. Clone the repository:

```bash
git clone https://github.com/nickmccullum/algorithmic-trading-recording.git
cd algorithmic-trading-recording
```

2. Create and activate a virtual environment:

```bash
cd project1
python -m venv .venv
source .venv/bin/activate  # Linux/macOS
# or .venv\Scripts\activate  # Windows
```

3. Install dependencies:

```bash
pip install -r requirements.txt
```

4. Configure environment variables:

```bash
cp .env.example .env
```

Then add your values to `.env`:

```dotenv
MASSIVE_API_KEY=your-massive-api-key-here
SNAPTRADE_CLIENT_ID=your-snaptrade-client-id
SNAPTRADE_CLIENT_SECRET=your-snaptrade-client-secret
```

5. Apply migrations:

```bash
python manage.py migrate
```

6. Run the development server:

```bash
python manage.py runserver
```

## Running the project

### Start Django app

```bash
python manage.py runserver
```

### Pull example market data

The repository includes a management command that can fetch sample market data for a set of tickers:

```bash
python manage.py pull_massive_data
```

This command calls the Massive client and prints the fetched results for a small test set such as `AAPL` and `NVDA`.

## Notes and caveats

- The repository is a work-in-progress trading prototype.
- The default database is SQLite, which is useful for local development but not production-scale deployment.
- Some parts of the project appear to be scaffolded and may require further implementation or refinement before use in a live trading environment.
- Several configuration values are read from environment variables and should never be committed to source control.

## License

No explicit license file is included in the repository at the moment. If you plan to reuse or distribute this code, verify the repo's intended licensing before production use.

## Summary

This repository demonstrates a practical quant trading architecture using Django, external market data, and brokerage APIs. It is structured around momentum-based stock selection and portfolio management, making it suitable as a starter project or research platform for algorithmic trading experiments.
