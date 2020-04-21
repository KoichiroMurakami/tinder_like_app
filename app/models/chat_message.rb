class ChatMessage < ApplicationRecord
    elongs_to :chat_room
    belongs_to :user
end
