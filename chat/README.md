# MCP Client 

This repository contains an asynchronous **MCP client** that connects to an MCP-compatible server (Python) and integrates with **Llama model** to process user queries.  
It automatically detects and uses tools provided by the server via MCP, allowing LLMs to call them dynamically.


## Features

- Connects to any MCP-compliant server (`.py`) 
- Lists and uses server-available tools dynamically
- Supports function calling for tool execution
- Maintains interactive chat loop
- Logs all interactions to `logs/llm_output.log`

## Chat Interface

In `client.py`, the main logic serves the purpose to create a chat interface between the user and the connected LLM. 

### System Message

The LLM is instructed that can use server primitives such as Resources or Tools. 
This instruction is specified in `system_message.txt`. 
Inside `client.py` the `system_message` is passed to the llm as the first object in the `messages`list. 
The description of all available tools and their arguments is also passed to the `messages` list. Since all the descriptions are sent to the client by the server, in order to add them to the list of messages `tool_schema_builder.py` is used to create a string for each primitive that the server exposes. 

> [!NOTE]
> The function calling in OpenAI style implies that the functions are passed at every invokation.
> But for token optimization, in this implementation, they are passed only once per conversation with the system message. 

### Query handling

After the user inserts a prompt, it's verified if it corresponds to two key words: `quit` or `prompt`. 
The first one closes the conversation. The second one opens the pre-written prompt window. In the latter, the user can choose one of the prompts that the server has among its primitives. This is handled by `snap4_prompts.py`.


If the query doesn't correspond to any keywords, then it's sent to the llm for a proper answer. If the LLM decides to answer with a function call, it's caught by the client and sent to the server for execution. When the client receives the answer, it's added to the list of messages and a new LLM invokation is required. 
This second invokation contains both the user's query and the answer from the tool execution. 
It is expected from the LLM to answer in natural language and analyze the results.

### After the query handling 

Wether a tool was called or not, the client returns to the user an answer. That answer is sent to the host that will print it. 


Finally, the user is asked again a query, in such a way that the conversation can continue. 

