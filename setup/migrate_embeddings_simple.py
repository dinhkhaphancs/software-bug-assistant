#!/usr/bin/env python3
"""
Simple migration script to add embeddings to existing tickets.
Standalone script that doesn't require the full agent system.
"""

import logging
import os
import sys
import psycopg2
from typing import List, Tuple

# Add the parent directory to the path to import from software_bug_assistant
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Import the embedding service from the main module
from embeddings.embeddings import get_embedding_service

def get_database_connection():
    """Get a database connection using environment variables or defaults."""
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST", "localhost"),
            port=os.getenv("DB_PORT", "5432"),
            database=os.getenv("DB_NAME", "ticketsdb"),
            user=os.getenv("DB_USER", "postgres"),
            password=os.getenv("DB_PASSWORD", "admin")
        )
        return conn
    except Exception as e:
        logger.error(f"Database connection failed: {e}")
        raise

def get_tickets_without_embeddings() -> List[Tuple[int, str, str, str, str, str]]:
    """Get tickets that don't have embeddings yet."""
    conn = get_database_connection()
    cursor = conn.cursor()
    
    try:
        cursor.execute("""
            SELECT ticket_id, title, description, assignee, priority, status
            FROM tickets 
            WHERE embedding IS NULL
            ORDER BY ticket_id
        """)
        tickets = cursor.fetchall()
        logger.info(f"Found {len(tickets)} tickets without embeddings")
        return tickets
    finally:
        cursor.close()
        conn.close()

def update_ticket_embedding(ticket_id: int, embedding: List[float]):
    """Update a ticket with its embedding."""
    conn = get_database_connection()
    cursor = conn.cursor()
    
    try:
        cursor.execute("""
            UPDATE tickets 
            SET embedding = %s::vector 
            WHERE ticket_id = %s
        """, (embedding, ticket_id))
        conn.commit()
        logger.info(f"Updated ticket {ticket_id} with embedding")
    finally:
        cursor.close()
        conn.close()

def main():
    """Main migration function."""
    logger.info("Starting embedding migration...")
    
    try:
        # Get the embedding service from the main module
        embedding_service = get_embedding_service()
        logger.info(f"Using embedding model: {embedding_service.model_name}")
        
        # Get tickets without embeddings (embedding column created by init-db.sql)
        tickets = get_tickets_without_embeddings()
        
        if not tickets:
            logger.info("No tickets need embedding updates")
            return
        
        # Process each ticket
        for ticket_id, title, description, assignee, priority, status in tickets:
            logger.info(f"Processing ticket {ticket_id}: {title[:50]}...")
            
            # Combine title, description, priority, and status for embedding
            # Include priority and status as they're important for ticket classification and search
            text_content = f"Title: {title}\n\nDescription: {description or ''}\n\nPriority: {priority or ''}\n\nStatus: {status or ''}"
            if assignee:
                text_content += f"\n\nAssignee: {assignee}"
            
            # Generate embedding
            embedding = embedding_service.generate_embedding(text_content)
            
            # Update ticket with embedding
            update_ticket_embedding(ticket_id, embedding)
        
        logger.info("✅ Embedding migration completed successfully!")
        logger.info(f"✅ Processed {len(tickets)} tickets")
        logger.info("✅ Vector index already created by database initialization")
        
    except Exception as e:
        logger.error(f"❌ Migration failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
