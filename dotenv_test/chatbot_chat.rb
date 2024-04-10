require 'http'
require 'json'
require 'dotenv'
Dotenv.load('.env')

def chatgpt(input, conversation_history)
  # Création de la clé d'API et indication de l'URL utilisée.
  api_key = ENV["OPENAI_API"]
  url = "https://api.openai.com/v1/chat/completions"

  # Un peu de JSON pour faire la demande d'autorisation d'utilisation à l'API OpenAI.
  headers = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{api_key}"
  }

  # Construire la liste des messages avec l'historique de conversation
  messages = conversation_history + [{ "role" => "user", "content" => input }]
  # Supprimer les messages avec le rôle "ai" de l'historique de conversation
  messages.reject! { |message| message["role"] == "ai" }

  # Un peu de JSON pour envoyer des informations directement à l'API.
  data = {
    "messages" => messages,
    "max_tokens" => 500,
    "temperature" => 0,
    "model" => "gpt-3.5-turbo"
  }
  # Envoi de la requête à l'API OpenAI
  response = HTTP.post(url, headers: headers, body: data.to_json)
  response_body = JSON.parse(response.body.to_s)

  # Vérifier si la réponse est valide
  if response_body.key?('choices') && response_body['choices'][0].key?('message') && response_body['choices'][0]['message'].key?('content')
    response_string = response_body['choices'][0]['message']['content'].strip

    # Retourner la réponse
    return response_string
  else
    return "Erreur : la structure de la réponse est invalide"
  end
end

def perform
  conversation_history = [{ "role" => "system", "content" => "Parle moi des chiens" }]
  loop do
    print "Toi (dit 'stop' si t'en peux plus): "
    input = gets.chomp
    break if input.downcase == 'stop'

    response_gpt = chatgpt(input, conversation_history)
    puts "IA : #{response_gpt}"

    # Ajouter la question de l'utilisateur et la réponse de l'IA à l'historique de conversation
    conversation_history << { "role" => "user", "content" => input }
    conversation_history << { "role" => "ai", "content" => response_gpt }
  end
end

perform
