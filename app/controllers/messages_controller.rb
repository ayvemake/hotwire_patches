class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]

  # GET /messages or /messages.json
  def index
    @messages = Message.all
    @message = Message.new
  end

  # GET /messages/1 or /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream.update(dom_id(@message),
          partial: "messages/messages_form",
          locals: { message: @message })
      end
    end
  end

  # POST /messages or /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.turbo_stream
        format.html { redirect_to @message, notice: "Message was successfully created." }
        format.json { render :show, status: :created, location: @message }
      else
        format.turbo_stream { render :create_error }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.turbo_stream do
          render turbo_stream.update(dom_id(@message),
            partial: "messages/message",
            locals: { message: @message })
        end
        format.html { redirect_to @message, notice: "Message was successfully updated." }
      else
        format.turbo_stream do
          render turbo_stream.update(dom_id(@message),
            partial: "messages/messages_form",
            locals: { message: @message })
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to messages_path, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find_by(id: params[:id])
      unless @message
        redirect_to messages_path, alert: "Message not found."
      end
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:content)
    end
end
