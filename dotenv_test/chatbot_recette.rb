# ligne très importante qui appelle les gems.
require 'http'
require 'json'
require 'dotenv'
Dotenv.load('.env')


# Création de la clé d'API et indication de l'URL utilisée.
api_key = ENV["OPENAI_API"]
url = "https://api.openai.com/v1/chat/completions"

# Un peu de JSON pour faire la demande d'autorisation d'utilisation à l'API OpenAI.
headers = {
  "Content-Type" => "application/json",
  "Authorization" => "Bearer #{api_key}"
}

# Un peu de JSON pour envoyer des informations directement à l'API.
data = {
  "messages" => [{"role" => "system", "content" => "Affiche-moi une recette de cuisine aléatoire."}],
  "max_tokens" => 200,  # Limite de tokens augmentée pour la recette
  "temperature" => 0.5,
  "model" => "gpt-3.5-turbo"
}

# Envoi de la requête à l'API OpenAI.
response = HTTP.post(url, headers: headers, body: data.to_json)
response_body = JSON.parse(response.body.to_s)

# Vérifier si la réponse est valide.
if response_body.key?('choices') && response_body['choices'][0].key?('message') && response_body['choices'][0]['message'].key?('content')
  response_string = response_body['choices'][0]['message']['content'].strip

  # Affichage du résultat.
  puts "Hello, voici une recette de cuisine aléatoire :"
  puts response_string
else
  puts "Erreur: la structure de la réponse est invalide."
end
