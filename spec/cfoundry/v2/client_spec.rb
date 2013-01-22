require 'spec_helper'

describe CFoundry::V2::Client do
  let(:client) { CFoundry::V2::Client.new }

  describe "#register" do
    let(:uaa) { CFoundry::UAAClient.new }
    let(:email) { 'test@test.com' }
    let(:password) { 'secret' }

    subject { client.register(email, password) }

    it "creates the user in uaa and ccng" do
      stub(client.base).uaa { uaa }
      stub(uaa).add_user(email, password) { { "id" => "1234" } }

      user = fake(:user)
      stub(client).user { user }
      stub(user).create!
      subject
      expect(user.guid).to eq "1234"
    end
  end

  describe "#current_user" do
    subject {client.current_user }
    before { client.token = token }

    context "when there is no access_token_data" do
      let(:token) { {:access_token => "FOOBAR", :access_token_data => {}} }
      it { should eq nil }
    end

    context "when there is access_token_data" do
      let(:token) do
        {
          :access_token => "FOOBAR",
          :access_token_data => { :user_id => "123", :email => "guy@example.com" }
        }
      end

      it { should be_a CFoundry::V2::User }
      its(:guid) { should eq "123" }
      its(:emails) { should eq [{ :value => "guy@example.com"}] }
    end
  end

  describe "#version" do
    its(:version) { should eq 2 }
  end

  describe "login and login prompts" do
    include_examples "client login"
  end

  describe "#login" do
    subject { client.login(email, password) }

    it 'sets the current organization to nil' do
      client.current_organization = "org"
      expect { subject }.to change { client.current_organization }.from("org").to(nil)
    end

    it 'sets the current space to nil' do
      client.current_space = "space"
      expect { subject }.to change { client.current_space }.from("space").to(nil)
    end
  end
end