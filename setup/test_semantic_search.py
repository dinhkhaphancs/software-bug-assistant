#!/usr/bin/env python3
"""
Test semantic search functionality
"""

import sys
import os
import asyncio

# Add the parent directory to the path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from embedding.free_embeddings import get_embedding_service

async def test_semantic_search():
    """Test the semantic search functionality."""
    print("🧪 Testing Semantic Search")
    print("=" * 40)
    
    # Get the embedding service (synchronous call)
    embedding_service = get_embedding_service()
    
    # Test queries
    test_queries = [
        "login problems",
        "mobile display issues", 
        "database errors",
        "file upload failures"
    ]
    
    for i, query in enumerate(test_queries, 1):
        print(f"\n{i}. Query: '{query}'")
        print("-" * 30)
        
        try:
            results = embedding_service.search_similar_tickets_sync(query, limit=3)
            
            if results:
                print(f"✅ Found {len(results)} results:")
                for j, result in enumerate(results, 1):
                    ticket_id = result['ticket_id']
                    title = result['title']
                    similarity = result.get('similarity', 0)
                    print(f"   {j}. #{ticket_id}: {title[:50]}...")
                    print(f"      Similarity: {similarity:.3f}")
            else:
                print("❌ No results found")
                
        except Exception as e:
            print(f"❌ Error: {e}")
    
    print("\n" + "=" * 40)
    print("🎯 Test completed!")

if __name__ == "__main__":
    asyncio.run(test_semantic_search())
