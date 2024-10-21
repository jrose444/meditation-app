require 'net/http'
require 'uri'
require 'json'

class ChatgptService
  API_ENDPOINT = "https://api.openai.com/v1/chat/completions".freeze

  def initialize
    @api_key = ENV['OPENAI_API_KEY']
  end

  def generate_meditation_script(prompt, max_tokens = 500)
    uri = URI(API_ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{@api_key}"
    request.body = {
      model: "gpt-3.5-turbo",
      messages: [
        { role: "system", content: "You are a skilled meditation guide." },
        { role: "user", content: prompt }
      ],
      max_tokens: max_tokens
    }.to_json

    response = http.request(request)
    response_body = JSON.parse(response.body)

    response_body["choices"][0]["message"]["content"]

    # actual_response = "As you make yourself comfortable, take a deep breath in, and let it out slowly. Take another deep breath in, and as you exhale, allow your eyes to gently close. Breathing deeply in and out, feel yourself sinking into the surface below you, letting go of any tension or tightness in your body.\n\nImagine a gentle wave of relaxation flowing through you, starting at the top of your head and slowly moving down through your body. As this wave flows, feel every muscle and fiber in your body becoming loose and limp, heavy and relaxed.\n\nWith each breath you take, allow the wave of relaxation to deepen, allowing yourself to drift deeper and deeper into a state of peaceful tranquility. Let go of any thoughts or worries, and simply focus on the sensation of relaxation spreading throughout your body.\n\nIn this state of deep relaxation, you are safe and supported. Your mind is clear and open, ready to embark on this journey of self-discovery and inner exploration.\n\nNow, take a few moments to enjoy this deep state of relaxation, allowing yourself to fully surrender to the present moment. In this space of calm and tranquility, you are completely at ease, completely at peace.\n\nI will count down from five to one, and with each number, feel yourself becoming more and more relaxed, more and more at peace.\n\nFive... Drifting deeper and deeper into relaxation.\nFour... Letting go of any tension or stress.\nThree... Feeling completely at ease and at peace.\nTwo... Surrendering to the stillness within you.\nOne... Deeply relaxed, deeply at peace.\n\nStay in this state of relaxation for as long as you desire, allowing yourself to fully immerse in this peaceful state of being. When you are ready to return to your usual state of awareness, simply open your eyes and bring your attention back to the present moment." 

    # response_body["choices"].first["message"]["content"]
  end

  def create_voice(text, title)
    uri = URI("https://api.openai.com/v1/audio/speech")

    # Create the HTTP request
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, {
      'Authorization' => "Bearer #{@api_key}",
      'Content-Type' => 'application/json'
    })

    # Define the request body with the text to be converted
    request.body = {
      "model": "tts-1",
      "input": text,
      "voice": "alloy"
    }.to_json

    # Send the request and get the response
    response = http.request(request)

    # Handle the response
    if response.is_a?(Net::HTTPSuccess)
      File.open("#{title}.mp3", "wb") { |file| file.write(response.body) }
      puts "Audio content written to #{title}.mp3"
    else
      puts "Error: #{response.code} - #{response.message}"
    end
  end
end