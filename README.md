# Chat interface connected to MCP server

This repository contains a chat interface that responds using `llama4-interface`. If needed, it uses tools exposed by an MCP Server. It automatically detects and uses the most appropriate tool.

## How to use

### 1. Connect to DISIT LAB LLM 
> [!TIP]
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

Query: list all the available tpl agencies and their websites. 
```

If the model decides to use a tool, you’ll see it in the log and terminal output.
Otherwise, the model will answer directly.

