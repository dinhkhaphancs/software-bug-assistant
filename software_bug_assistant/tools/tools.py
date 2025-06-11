# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
Tools for the Software Bug Assistant
Includes free embedding functionality for semantic search
"""

from datetime import datetime
import os
import json
from typing import Dict, Any, List

from google.adk.agents import Agent
from google.adk.tools import google_search
from google.adk.tools.agent_tool import AgentTool
from toolbox_core import ToolboxSyncClient

from dotenv import load_dotenv

from embeddings.embeddings import get_embedding_service, generate_embedding

# Load environment variables
load_dotenv()


# ----- Example of a Function tool -----
def get_current_date() -> dict:
    """
    Get the current date in the format YYYY-MM-DD
    """
    return {"current_date": datetime.now().strftime("%Y-%m-%d")}

# ----- Example of a Function tool -----
def get_most_handsome_boy_name() -> dict:
    """
    Get the name of the most handsome
    """
    return {"name": "Kha dep zai", "reason": "Because he is the most handsome"}


# ----- Free Vector Search Tool -----
def search_tickets_semantic(query: str, limit: int = 10) -> Dict[str, Any]:
    """
    Search for similar tickets using free semantic embeddings.
    
    Args:
        query: The search query text
        limit: Maximum number of results to return
        
    Returns:
        Dictionary with search results or error message
    """
    if not generate_embedding:
        return {
            "error": "Vector search not available. Please install sentence-transformers: pip install sentence-transformers"
        }
    
    try:
        
        # Get embedding service
        embedding_service = get_embedding_service()
        
        # Use synchronous search to avoid async issues
        results = embedding_service.search_similar_tickets_sync(query, limit)
        
        return {
            "query": query,
            "results": results,
            "search_type": "semantic_vector",
            "model": "sentence-transformers/all-MiniLM-L6-v2",
            "total_results": len(results)
        }
        
    except Exception as e:
        return {
            "error": f"Semantic search failed: {str(e)}",
            "query": query,
            "fallback_suggestion": "Try using the regular text search instead"
        }


# ----- Example of a Built-in Tool -----
search_agent = Agent(
    model="gemini-2.0-flash",
    name="search_agent",
    instruction="""
    You're a specialist in Google Search.
    """,
    tools=[google_search],
)

search_tool = AgentTool(search_agent)


# ----- Example of Google Cloud Tools (MCP Toolbox for Databases) -----
TOOLBOX_URL = os.getenv("MCP_TOOLBOX_URL", "http://127.0.0.1:5001")

# Initialize Toolbox client
toolbox = ToolboxSyncClient(TOOLBOX_URL)
# Load all the tools from toolset
toolbox_tools = toolbox.load_toolset("tickets_toolset")
