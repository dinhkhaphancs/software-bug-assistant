# Simple Setup

Manual setup for the Software Bug Assistant with simplified, streamlined code.

## Prerequisites

- **uv**: Install with `curl -LsSf https://astral.sh/uv/install.sh | sh`
- **Docker**: For running PostgreSQL database

## Setup Steps

1. **Install project and dependencies**:
   ```bash
   cd .. && uv pip install -e .
   ```

2. **Start database**:
   ```bash
   docker-compose up -d
   ```

3. **Generate embeddings**:
   ```bash
   uv run migrate_embeddings_simple.py
   ```

4. **Test semantic search**:
   ```bash
   uv run test_semantic_search.py
   ```

## Database Connection

- **Host**: localhost:5432
- **Database**: ticketsdb  
- **Username**: postgres
- **Password**: admin

## Code Simplifications

The setup has been streamlined with the following improvements:

### Removed Files
- `setup.py` - Automated setup script (manual process only)
- `requirements.txt` - Redundant with pyproject.toml
- `software_bug_assistant.egg-info/` - Auto-generated package metadata

### Consolidated Code
- **Database utilities** - Shared `db_utils.py` with environment variable support
- **Embedding service** - Unified `FreeEmbeddingService` class with both sync/async methods
- **Migration script** - Standalone script that doesn't require full agent system
- **Dependencies** - Pure uv-based approach in `pyproject.toml`

### Files

- `docker-compose.yml` - PostgreSQL database with pgvector extension
- `init-db.sql` - Database schema, sample data, and vector index
- `migrate_embeddings_simple.py` - Standalone embedding migration
- `test_semantic_search.py` - Test script for semantic search functionality
