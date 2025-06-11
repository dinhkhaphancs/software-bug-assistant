"""
Test the search_tickets_semantic function
"""

import sys
import os

# Add the parent directory to the path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from software_bug_assistant.tools.tools import search_tickets_semantic

def test_semantic_search_tool():
    """Test the semantic search tool function."""
    print("🧪 Testing search_tickets_semantic function")
    print("=" * 50)
    
    test_queries = [
        "login issues",
        "database problems", 
        "file upload errors",
        "Urgent: A sophisticated supply"
    ]
    
    for i, query in enumerate(test_queries, 1):
        print(f"\n{i}. Testing query: '{query}'")
        print("-" * 40)
        
        try:
            result = search_tickets_semantic(query)
            
            if "error" in result:
                print(f"❌ Error: {result['error']}")
            else:
                print(f"✅ Found {result.get('total_results', 0)} results")
                print(f"Search type: {result.get('search_type')}")
                print(f"Model: {result.get('model')}")
                
                if result.get('results'):
                    for j, ticket in enumerate(result['results'][:3], 1):
                        print(f"   {j}. #{ticket['ticket_id']}: {ticket['title'][:50]}...")
                        print(f"      Similarity: {ticket.get('similarity', 0):.3f}")
        except Exception as e:
            print(f"❌ Exception: {e}")
            import traceback
            traceback.print_exc()
    
    print("\n" + "=" * 50)
    print("🎯 Test completed!")

if __name__ == "__main__":
    test_semantic_search_tool()
