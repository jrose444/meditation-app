class Api::V1::ItemsController < ApplicationController

    # GET /api/v1/items
    def index
        # all scripts for a person
      render json: { message: "This is the index action. Here you would return all items." }
    end
    # GET /api/v1/items/:id
    def show
        # single script
      render json: { message: "This is the show action. Here you would return a specific item by ID." }
    end
  
    # POST /api/v1/items
    def create
        # generate script
        input_text = params[:text]  # Get the text sent from the React frontend
        script = ::ChatgptService.new.generate_meditation_script(input_text, max_tokens = 500)
        render json: { message: "Received text: #{script}" }, status: :ok
    end
  
    # PUT/PATCH /api/v1/items/:id
    def update
        # update script
      render json: { message: "This is the update action. Here you would update an item by ID." }
    end
  
    # DELETE /api/v1/items/:id
    def destroy
      render json: { message: "This is the destroy action. Here you would delete an item by ID." }, status: :no_content
    end
  end