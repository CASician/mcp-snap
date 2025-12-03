# Logging

This directory contains all the logs that the mcp application creates. 

All queries, raw model responses, and tool calls are saved in:

```
llm_output.log
```

> [!TIP]
> If the file dimensions makes log reading difficult, change the name of the file currently inspecting. 
> When the application is used again and doesn't find a file named `llm_output.log` it creates a new one. 

Example excerpt:

```
2025-10-02 09:23:17 USER QUERY: calculate the area of a circle with radius 5
2025-10-02 09:23:18 PARSED SUCCESS
2025-10-02 09:23:19 FIRST RESPONSE: {'role': 'assistant', 'content': None, 'function_call': {'name': 'tool_name', 'arguments': {...}}}
2025-10-02 09:23:19 FUNCTION CALLED: math_tool
2025-10-02 09:23:20 FOLLOWUP RESPONSE: The area is approximately 78.54.
```

## How to read it
Each conversation is divided by a specific divider: 
```
=====
```

The normal flow follows the schema in the example above: 
1. USER QUERY
1. PARS
1. REASONING TEXT
1. FIRST RESPONSE
1. FUNCTION CALLED
1. FOLLOWUP RESPONSE

If parsing fails, the first response is printed to the user, otherwise, only the followup appears.
