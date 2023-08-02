# app/controllers/todo_controller.rb
class TodoController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create]
  
    def index
      todo_items = [
        { id: 1, text: 'Buy groceries' },
        { id: 2, text: 'Pay bills' },
        { id: 3, text: 'Finish the project' }
      ]
      render html: todo_items
    end
  
    def create
      new_item = { id: 4, text: params[:text] }
      render json: { message: 'Item added successfully!', item: new_item }, status: :created
    end
  end
  