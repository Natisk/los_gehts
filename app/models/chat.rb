# frozen_string_literal: true

class Chat < ApplicationRecord
  belongs_to :user, inverse_of: :chats

  attr_accessor :message

  def message=(message)
    messages = [ { "role" => "system", "content" => message } ]

    self.q_and_a.each do |question, answer|
      messages << { "role" => "user", "content" => quesiton }
      messages << { "role" => "assistant", "content" => answer }
    end

    messages << { "role" => "user", "content" => message } if messages.size > 1

    response_raw = open_ai_client.chat(parameters: {
                                    model: "gpt-3.5-turbo",
                                    messages:,
                                    temperature: 0.7,
                                    max_tokens: 500,
                                    top_p: 1,
                                    frequency_penalty: 0.0,
                                    presence_penalty: 0.6
                                  })
    Rails.logger response_raw

    response = JSON.parse(response_raw.to_json, object_class: OpenStruct)

    self.q_and_a << [ message, response.choices[0].message.content ]
  end

  private

  def open_ai_client
    OpenAI::Client.new
  end
end
