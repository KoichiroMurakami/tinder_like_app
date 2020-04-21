class ChatController < ApplicationController
    def create
        # get user's own chat room 
        current_user_chat_rooms = ChatRoomUser.where(user_id: current_user.id).map(&:chat_room)
        # find chatroom where other users are 
        chat_room = ChatRoomUser.where(chat_room: current_user_chat_rooms, user_id: params[:user_id]).map(&:chat_room).first
        # create chat room if not present
        if chat_room.blank?
            # create record on chat room table  
            chat_room = ChatRoom.create
            ChatRoomUser.create(chat_room: chat_room, user_id: current_user.id)
            ChatRoomUser.create(chat_room: chat_room, user_id: params[:user_id])
        end
        # redirect to chat_room
        redirect_to action: :show, id: chat_room.id
    end

    def show
        # get other users' info in the chat room
        chat_room = ChatRoom.find_by(id: params[:id])
        @chat_room_user = chat_room.chat_room_users.
            where.not(user_id: current_user.id).first.user
        @chat_messages = ChatMessage.where(chat_room: chat_room).order(:created_at)
    end
end
