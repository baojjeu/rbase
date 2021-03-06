require "rails_helper"
RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  include Devise::TestHelpers
  let!(:user) { create(:user) }
  let!(:user_social) { create(:user_social, user_id: user.id) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  context "method test" do
    before { OmniAuth.config.mock_auth[:facebook] = facebook_hash }
    describe "UserSocial custom method test" do
      it "find_user_by_uid" do
        expect(UserSocial).to receive_message_chain(:where, :first)
        UserSocial.find_user_social_by_uid(user_social.provider, user_social.uid)
      end

      it "description" do
        expect(user_social).to receive_message_chain(:update_attributes)
        user_social.update_social_data(facebook_hash)
      end
    end

    describe "User custom method test" do
      it "create_user_social" do
        expect(user).to receive_message_chain(:user_socials, :create)
        user.create_user_social(facebook_hash)
      end
    end
  end

  context "Facebook" do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = facebook_hash
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    end

    describe "user has user_social" do
      before { expect(UserSocial).to receive(:find_user_social_by_uid).and_return(user_social) }
      it "should update social data" do
        expect(user_social).to receive(:update_social_data)
        get :facebook
        expect(response).to redirect_to root_path
      end
    end

    describe "user doesn't has user_social but has same email" do
      before { expect(UserSocial).to receive(:find_user_social_by_uid).and_return(nil) }
      it "should create social data" do
        facebook_hash["info"]["email"] = user.email
        expect(User).to receive(:find_by_email).and_return(user)
        expect(user).to receive(:create_user_social)
        get :facebook
        expect(response).to redirect_to root_path
      end
    end

    describe "user doesn't has user_social and has different email" do
      before { expect(UserSocial).to receive(:find_user_social_by_uid).and_return(nil) }
      it "should create social data" do
        get :facebook
        expect(response).to redirect_to new_user_registration_url
      end
    end
  end

  context "Google" do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = google_oauth2_hash
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    end
    describe "user has user_social" do
      before { expect(UserSocial).to receive(:find_user_social_by_uid).and_return(user_social) }
      it "should update social data" do
        expect(user_social).to receive(:update_social_data)
        get :google_oauth2
        expect(response).to redirect_to root_path
      end
    end

    describe "user doesn't has user_social but has same email" do
      before { expect(UserSocial).to receive(:find_user_social_by_uid).and_return(nil) }
      it "should create social data" do
        google_oauth2_hash["info"]["email"] = user.email
        expect(User).to receive(:find_by_email).and_return(user)
        expect(user).to receive(:create_user_social)
        get :google_oauth2
        expect(response).to redirect_to root_path
      end
    end

    describe "user doesn't has user_social and has different email" do
      before { expect(UserSocial).to receive(:find_user_social_by_uid).and_return(nil) }
      it "should create social data" do
        get :google_oauth2
        expect(response).to redirect_to new_user_registration_url
      end
    end
  end

  context "Weibo" do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:weibo] = weibo_hash
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:weibo]
    end
    describe "user has user_social" do
      before { expect(UserSocial).to receive(:find_user_social_by_uid).and_return(user_social) }
      it "should update social data" do
        expect(user_social).to receive(:update_social_data)
        get :weibo
        expect(response).to redirect_to root_path
      end
    end

    describe "user doesn't has user_social but has same email" do
      before { expect(UserSocial).to receive(:find_user_social_by_uid).and_return(nil) }
      it "should create social data" do
        weibo_hash["info"]["email"] = user.email
        expect(User).to receive(:find_by_email).and_return(user)
        expect(user).to receive(:create_user_social)
        get :weibo
        expect(response).to redirect_to root_path
      end
    end

    describe "user doesn't has user_social and has different email" do
      before { expect(UserSocial).to receive(:find_user_social_by_uid).and_return(nil) }
      it "should create social data" do
        get :weibo
        expect(response).to redirect_to new_user_registration_url
      end
    end
  end
end
