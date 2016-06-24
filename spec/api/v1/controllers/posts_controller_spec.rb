require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) } # we build post and associate with topic
  let(:my_comment) { Comment.create!(body: RandomData.random_paragraph, post: my_post, user: my_user) }

  context "unauthenticated user" do

    #UPDATE
    it "PUT update returns http unauthenticated" do #functional
      put :update, topic_id: my_topic.id, id: my_post.id, post: {title: "Post Title", body: "Post Body"}
      expect(response).to have_http_status(401)
    end

    #CREATE
    it "POST create returns http unauthenticated" do #functional
      post :create, topic_id: my_topic.id, post: {title: "Post Title", body: "Post Body"}
      expect(response).to have_http_status(401)
    end

    #DELETE/DESTROY
    it "DELETE destroy returns http unauthenticated" do #functional
      delete :destroy, topic_id: my_topic.id, id: my_post.id
      expect(response).to have_http_status(401)
    end
  end

  context "unauthorized user" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    #UPDATE
    it "PUT update returns http forbidden" do #functional
      put :update, topic_id: my_topic.id, id: my_post.id, post: {title: "Post Title", body: "Post Body"}
      expect(response).to have_http_status(403)
    end

    #CREATE
    it "POST create returns http forbidden" do #functional
      post :create, topic_id: my_topic.id, post: {title: "Post Title", body: "Post Body", topic: my_topic}
      expect(response).to have_http_status(403)
    end

    #DELETE/DESTROY
    it "DELETE destroy returns http forbidden" do #functional
      delete :destroy, topic_id: my_topic.id, id: my_post.id
      expect(response).to have_http_status(403)
    end
  end

  context "authenticated and authorized users" do
    before do
      my_user.admin!
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    #UPDATE
    describe "PUT update" do
      before do
        put :update, topic_id: my_topic.id, id: my_post.id, post: {title: my_post.title, body: my_post.body, topic: my_topic}
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "updates a post with the correct attributes" do
        updated_post = Post.find(my_post.id)
        expect(response.body).to eq(updated_post.to_json)
      end
    end

    #CREATE
    describe "POST create" do
      before do
        post :create, topic_id: my_topic.id, user_id: my_user.id, post: {title: my_post.title, body: my_post.body, topic: my_topic, user: my_user}
      end

      it "returns http success" do#error
        expect(response).to have_http_status(:success)#problem 400
      end

      it "returns json content type" do #functional
        expect(response.content_type).to eq 'application/json'
      end

      it "creates a post with the correct attributes" do
        hashed_json = JSON.parse(response.body)
        expect(hashed_json["title"]).to eq(my_post.title)#problem got nil
        expect(hashed_json["body"]).to eq(my_post.body)
      end
    end

    #DESTROY
    describe "DELETE destroy" do
      before do
        delete :destroy, topic_id: my_topic.id, id: my_post.id
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "returns the correct json success message" do
        expect(response.body).to eq({ message: "Post destroyed", status: 200 }.to_json)
      end

      it "deletes my_topic" do
        expect{ Post.find(my_post.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
