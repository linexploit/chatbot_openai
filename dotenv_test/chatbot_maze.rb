require 'http'
require 'json'
require 'dotenv'
Dotenv.load('.env')

def chatgpt(input)
  api_key = ENV["OPENAI_API"]
  url = "https://api.openai.com/v1/chat/completions"

  headers = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{api_key}"
  }

  data = {
    "messages" => [{ "role" => "user", "content" => input }],
    "max_tokens" => 1000,
    "temperature" => 0.5,
    "model" => "gpt-3.5-turbo"
  }

  response = HTTP.post(url, headers: headers, body: data.to_json)
  response_body = JSON.parse(response.body.to_s)

  if response_body.key?('choices') && response_body['choices'][0].key?('message') && response_body['choices'][0]['message'].key?('content')
    response_string = response_body['choices'][0]['message']['content'].strip
    return response_string
  else
    return "Erreur : la structure de la réponse est invalide"
  end
end

def run_labyrinthe
  output = `ruby labyrinthe.rb 2>&1`
  return output
end

def perform
  loop do
    puts "Que voulez-vous faire ? (Tapez 'stop' pour quitter)"
    input = gets.chomp
    break if input.downcase == 'stop'

    output = run_labyrinthe
    puts "Sortie du labyrinthe :"
    puts output

    puts "Analyse des erreurs par le chatbot :"
    help_response = chatgpt(output)
    puts "Chatbot : #{help_response}"
  end
end

perform
