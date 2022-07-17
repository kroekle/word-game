# Word Game

This is rego and data that will simulate a popular word game.  It's written in a way that utilizes the REST interface of Open Policy Agent for the game itself.  It works best when using [Styra DAS Free](https://signup.styra.com/).  A blog was written around the creation of this, that can be found [here]().

## Setup
  * In Styra DAS create a new custom system.  
  * Copy the .rego files in using the same package structure
  * Create a new https data source pointing to the raw url for the data.json
      * in the Advanced settings for the data source 
          * Data transform: Custom  
          * Policy to transform/words.rego
          * Rego query to data.transform.out
      
## Usage
Follow the install instructions for the DAS system that can be found system>Settings>Install

Use the following cURL to play (you can drop the pipe jq if you don't have jq installed):
```sh
curl localhost:8181 -s -d '{"jarvis":true, "word": 1286,"guesses": ["spite"]}' | jq
```
