# Chat interface connected to MCP server

This repository contains a chat interface that responds using `llama4-interface`. If needed, it uses tools exposed by an MCP Server. It automatically detects and uses the most appropriate tool.

## How to use

### 1. Connect to DISIT LAB LLM 
> [!NOTE]
> Skip this step if you are using DISIT VM. 

In the directory `llama4` create a new file called `user_credentials.json`.

It is Used by the client to authenticate to Snap4City and obtain an access token. You must use a Snap4City account that has been granted with the necessary API rules and usage limits.

```json
{
  "username": "<SNAP4CITY_USERNAME>",
  "password": "<PASSWORD>"
}
```

### 2. Run the chat interface 
The initialization steps are handled by the same command that starts the conversations with the LLM. In other words: you can start chatting right away with just one command: 

```bash
chat
```

This is an alias for `./chat.sh` and it only works inside the VM. If you are not using our VM, either create the same alias, or use the entire command.  

If successful, you'll see the token-handling and an output like: 

```
Connected to server with: 
TOOLS: [...]
RESOURCES: [...]
PROMPTS: [...]
``` 


### 3. Start chatting! 

Once connected, you can enter queries interactively:

```
MCP Client Started!
Type your queries or 'quit' to exit.
Type 'prompt' to select a pre-written prompt. 

 >>> Query: list all the available tpl agencies and their websites. 
```

If the model decides to use a tool, you’ll see it in the log and terminal output.
Otherwise, the model will answer directly.

## How it works

### Directory structure:

The main files are the following:

```
MCP Snap/
├── chat/
│   ├── client.py               # main logic
│   ├── snap4_prompts.py        # pre-written prompts handler 
│   ├── tool_schema_builder.py  # adds tools to system message 
│   ├── system_message.txt      # main instructions for the model 
│   └── README.md 
├── server/
│   ├── server.py               # all the tools, resources and prompts
│   └── README.md 
├── llama4/
│   ├── lab_llm.py              # main connection to DISIT and model answer handling
│   ├── token_manager.py        # this and below, the files are identical to the original 
│   ├── clearmml_config.json 
│   ├── [token_stored.json]      
│   ├── [user_credentials.json]
│   └── README.md 
├── logs/
│   ├── llm_output.log
│   └── [other logs...] 
├── init.sh
├── chat.sh
└── README.md
```

### What happens to the user's query?

The user's query is handled by the `chat_loop()` function in `chat/client.py`. It runs a loop until the user decides to quit. The messages are all stored and handled by `process_query(query)`. More precisely:

```
Process a query using LLM and available tools/resources/prompts. 
Workflow:
1. Append the user's query in messages = []
2. Call the LLM with user's query.
3. Check if the answer has "function_call"
    4a. NO FUNCTION CALL: return answer (and append it to messages)
4. FUNCTION CALL DETECTED: parse the answer to reconstruct function.
5. Ask server to call the function. 
6. Append result in messages. 
7. Call the LLM again, to process the answer in natural language 
8. Append second answer to messages and return it. 


The LLM returns a json object as such:
{ 
    "choices": [
        "message": {
            "role": "assistant",
            "content": "THE ANSWER" # if there is a function call, this is `null`
            "function_call": {
                "name": "function_name"
                "arguments": { ... } 
            }
        }
    ]    
}

This structure mimics what is the standard OpenAI structure. But it needs improvements. 
``` 

If you want to check if the model has allucinated or it actually executed a function call, open `log/llm_output.log`, scroll until the end and look for how the first answer has been parsed. 
If you see:
```
PARSE SUCCESS
FIRST RESPONSE: JSON OBJECT 
FUNCTION CALLED: function_name
```
the function has been called successfully with the parameters stated in FIRST RESPONSE.  
Otherwise, you will only see: 

```
PARSE FAIL
FIRST RESPONSE: [full answer received in chat]
```

