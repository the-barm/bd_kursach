class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :index]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = Micropost.new(micropost_params)
    @micropost.user_id = current_user.id
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def index 
    @microposts = params[:search] ? Micropost.where(content: /#{Regexp.escape(params[:search])}/i).all.paginate(page: params[:page]) : params[:search]
  end

  def destroy
    Micropost.destroy(@micropost.id)
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
    
    def correct_user
      if current_user.admin?
        @micropost = Micropost.find(params[:id])
      else
        @micropost = current_user.microposts.find(params[:id])
      end
      redirect_to root_url if @micropost.nil?
    end
end
