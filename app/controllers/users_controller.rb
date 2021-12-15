class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy sync_events]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    if @user.auth_config['access_token']
      @events = @user.events.present? ? @user.events : Event.none
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def oauth_callback
    state = JSON.parse params[:state]
    user = User.find(state['id'])
    return unless params[:code] && user.present?

    connection = Faraday.new(url: TOKEN_URL)
    request_body = {
      code: params['code'],
      grant_type: 'authorization_code',
      redirect_uri: CALLBACK_URL,
      client_id: Rails.application.credentials.config[:google][:client_id],
      client_secret: Rails.application.credentials.config[:google][:client_secret]
    }
    response = connection.send('post') do |request|
      request.headers['Content-Type'] = 'application/json'
      request.body = request_body.to_json
    end

    if response&.body && response.status == 200
      message = 'Authorization successful'
      body = JSON.parse(response.body)
      Rails.logger.info body.inspect
      if body['access_token']
        user.update(auth_config: { access_token: body['access_token'], expired: false })
        # user.sync_events
      else
        message = "Authorization failed, Please try again! #{body.error}"
      end
      render html: message
    end
  end

  def sync_events
    event_meta = @user.load_events
    if event_meta&.[]('error')
      auth_config = @user.auth_config.dup
      auth_config[:expired] = true
      @user.update(auth_config: auth_config)
      return render json: event_meta['error']
    end
    if event_meta && event_meta['items']
      event_meta['items'].each do |e|
        event = @user.events.find_by_eid(e['id'])
        event = @user.events.new event if !event
        event.update(
          eid: e['id'], status: e['status'], summary: e['summary'],
          description: e['description'], organizer: e['organizer']['email'],
          from_time: e['start']['dateTime'], to_time: e['end']['dateTime'],
        )
      end
    end
    redirect_to user_path(@user), notice: 'Google Calendar events synced successfully.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
