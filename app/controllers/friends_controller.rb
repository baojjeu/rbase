class FriendsController < ApplicationController
  before_filter :redirect_to_sign_in
  def index
    facebook_auth = current_user.user_socials.where(provider: "facebook").first
    access_token = facebook_auth.token
    uid = facebook_auth.uid
    @user = FbGraph::User.me(access_token)
    @user = FbGraph::User.fetch(uid, access_token: access_token)
  end

  def like
    if current_user.create_like_if_nil(params[:id])
      redirect_to :back
      flash[:notice] = "已記錄下您的心意"
    else
      redirect_to :back
      flash[:alert] = "已經紀錄過囉"
    end
  end
end
