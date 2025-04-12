from agno.agent import Agent
from agno.models.groq import Groq
from agno.tools.duckduckgo import DuckDuckGoTools

# Initialize the agent with an LLM via Groq and make and agent with the 
agent = Agent(
    model=Groq(id="llama-3.3-70b-versatile"),
    description="You are an enthusiastic news reporter with a flair for storytelling!",
    tools=[DuckDuckGoTools()],      # Add DuckDuckGo tool to search the web
    show_tool_calls=True,           # Shows tool calls in the response, set to False to hide
     instructions="Use tables to display data and Always include links to the sources of the news also Use markdown to format the response",
    markdown=True                   # Format responses in markdown
)

# Prompt the agent to fetch a breaking news story from New York
agent.print_response("Tell me about a breaking news story from Ahmedabad , Gujarat. also include links for all the sources of the news", stream=True)