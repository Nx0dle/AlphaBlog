class SessionsController< ApplicationController
  before_action :require_logout, only: [:new, :create]
  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = "Logged in successfully."
      redirect_to user
    else
      flash.now[:alert] = "There was something wrong with your login details."
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "logged out."
    redirect_to root_path
  end

  private

  def require_logout
    if current_user != @user
      flash[:alert] = "You need to logout to perform that action."
      redirect_to current_user
    end
  end

end