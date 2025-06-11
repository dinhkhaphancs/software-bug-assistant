"""
Free Embedding Service using Sentence Transformers
Replaces Google's text-embedding-005 with 100% free local embeddings
"""

import os
import numpy as np
from typing import List, Union
import logging
from functools import lru_cache
from sentence_transformers import SentenceTransformer
import psycopg2


# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class FreeEmbeddingService:
    """
    Free embedding service using Sentence Transformers
    Provides embeddings compatible with pgvector
    """
    
    def __init__(self, model_name: str = "all-MiniLM-L6-v2"):
        """
        Initialize the embedding service
        
        Args:
            model_name: Model to use. Options:
                - "all-MiniLM-L6-v2" (384d, fast, good quality) - RECOMMENDED
                - "all-mpnet-base-v2" (768d, slower, best quality)  
                - "multi-qa-MiniLM-L6-cos-v1" (384d, optimized for Q&A)
        """
        self.model_name = model_name
        self.model = None
        self._load_model()
        
    def _load_model(self):
        """Load the embedding model (downloads if first time)"""
        try:
            logger.info(f"Loading embedding model: {self.model_name}")
            self.model = SentenceTransformer(self.model_name)
            logger.info(f"Model loaded successfully. Dimension: {self.get_embedding_dimension()}")
        except Exception as e:
            logger.error(f"Failed to load model {self.model_name}: {e}")
            raise
    
    def get_embedding_dimension(self) -> int:
        """Get the dimension of embeddings produced by this model"""
        return self.model.get_sentence_embedding_dimension()
    
    def generate_embedding(self, text: str) -> List[float]:
        """
        Generate embedding for a single text
        
        Args:
            text: Input text to embed
            
        Returns:
            List of floats representing the embedding vector
        """
        if not text or not text.strip():
            logger.warning("Empty text provided for embedding")
            return [0.0] * self.get_embedding_dimension()
            
        try:
            # Generate embedding
            embedding = self.model.encode(text, convert_to_numpy=True)
            return embedding.tolist()
        except Exception as e:
            logger.error(f"Error generating embedding: {e}")
            raise
    
    def generate_embeddings_batch(self, texts: List[str]) -> List[List[float]]:
        """
        Generate embeddings for multiple texts (more efficient)
        
        Args:
            texts: List of input texts to embed
            
        Returns:
            List of embedding vectors
        """
        if not texts:
            return []
            
        try:
            # Filter out empty texts
            valid_texts = [text if text and text.strip() else " " for text in texts]
            
            # Generate embeddings in batch
            embeddings = self.model.encode(valid_texts, convert_to_numpy=True)
            return embeddings.tolist()
        except Exception as e:
            logger.error(f"Error generating batch embeddings: {e}")
            raise
    
    def similarity(self, text1: str, text2: str) -> float:
        """
        Calculate similarity between two texts
        
        Args:
            text1: First text
            text2: Second text
            
        Returns:
            Cosine similarity score (higher = more similar)
        """
        embeddings = self.generate_embeddings_batch([text1, text2])
        
        # Calculate cosine similarity
        emb1 = np.array(embeddings[0])
        emb2 = np.array(embeddings[1])
        
        similarity = np.dot(emb1, emb2) / (np.linalg.norm(emb1) * np.linalg.norm(emb2))
        return float(similarity)
    
    def search_similar_tickets_sync(self, query: str, limit: int = 3) -> List[dict]:
        """
        Search for similar tickets using vector similarity
        
        Args:
            query: Search query text
            limit: Maximum number of results to return
            
        Returns:
            List of similar tickets with similarity scores
        """
        try:
            # Use local database connection function
            def get_database_connection():
                return psycopg2.connect(
                    host=os.getenv("DB_HOST", "localhost"),
                    port=os.getenv("DB_PORT", "5432"),
                    database=os.getenv("DB_NAME", "ticketsdb"),
                    user=os.getenv("DB_USER", "postgres"),
                    password=os.getenv("DB_PASSWORD", "admin")
                )
            
            # Generate embedding for query
            query_embedding = self.generate_embedding(query)
            
            # Connect to database
            conn = get_database_connection()
            
            with conn.cursor() as cur:
                # Search for similar tickets using vector similarity
                cur.execute("""
                    SELECT ticket_id, title, description, assignee, priority, status,
                           (embedding <-> %s::vector) as distance
                    FROM tickets 
                    WHERE embedding IS NOT NULL
                    ORDER BY distance ASC
                    LIMIT %s;
                """, (query_embedding, limit))
                
                results = []
                for row in cur.fetchall():
                    ticket_id, title, description, assignee, priority, status, distance = row
                    results.append({
                        'ticket_id': ticket_id,
                        'title': title,
                        'description': description,
                        'assignee': assignee,
                        'priority': priority,
                        'status': status,
                        'similarity': 1.0 - distance  # Convert distance to similarity
                    })
                
            conn.close()
            return results
            
        except Exception as e:
            logger.error(f"Error searching similar tickets: {e}")
            return []

# Global instance (singleton pattern)
_embedding_service = None

def get_embedding_service(model_name: str = "all-MiniLM-L6-v2") -> FreeEmbeddingService:
    """Get the global embedding service instance"""
    global _embedding_service
    if _embedding_service is None or _embedding_service.model_name != model_name:
        _embedding_service = FreeEmbeddingService(model_name)
    return _embedding_service

# Convenience functions
def generate_embedding(text: str, model_name: str = "all-MiniLM-L6-v2") -> List[float]:
    """Generate embedding for text using default model"""
    service = get_embedding_service(model_name)
    return service.generate_embedding(text)


# Test function
def test_embeddings():
    """Test the embedding service"""
    print("Testing Free Embedding Service...")
    
    # Test texts
    texts = [
        "Login page freezes after failed attempts",
        "User authentication page becomes unresponsive", 
        "Database connection timeout error",
        "PDF export truncates text fields"
    ]
    
    service = get_embedding_service()
    print(f"Model: {service.model_name}")
    print(f"Embedding dimension: {service.get_embedding_dimension()}")
    
    # Generate embeddings
    embeddings = service.generate_embeddings_batch(texts)
    print(f"Generated {len(embeddings)} embeddings")
    
    # Test similarity
    similarity_score = service.similarity(texts[0], texts[1])
    print(f"Similarity between '{texts[0]}' and '{texts[1]}': {similarity_score:.3f}")
    
    similarity_score = service.similarity(texts[0], texts[2])
    print(f"Similarity between '{texts[0]}' and '{texts[2]}': {similarity_score:.3f}")
    
    print("✅ Embedding service test completed successfully!")

if __name__ == "__main__":
    test_embeddings()
