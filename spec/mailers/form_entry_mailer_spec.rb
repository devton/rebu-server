require "rails_helper"

RSpec.describe FormEntryMailer, type: :mailer do
  describe "#thank_you_email" do
    before do
      @user = stub_model(User, email: "fooz@barz.com")

      @mobilization = stub_model(
        Mobilization,
        name: "My Mobilization Name",
        facebook_share_url: "http://facebook.com/share",
        twitter_share_url: "http://twitter.com/share",
        user: @user
      )

      @widget = stub_model(
        Widget, mobilization: @mobilization,
        settings: {email_text: "Thank you for doing this!"}
      )

      @form_entry = stub_model FormEntry, widget: @widget, email: "foo@bar.com"
    end

    it "should send an email to the properly destination" do
      email = FormEntryMailer.thank_you_email(@form_entry, true).deliver_now
      expect(email.to).to be_eql([@form_entry.email])
    end

    it "should send an email with the properly sender" do
      email = FormEntryMailer.thank_you_email(@form_entry, true).deliver_now
      expect(email.from).to be_eql([@mobilization.user.email])
    end

    it "should send an email with the properly subject" do
      email = FormEntryMailer.thank_you_email(@form_entry, true).deliver_now
      expect(email.subject).to include(@mobilization.name)
    end

    it "should send an email with the properly body" do
      email = FormEntryMailer.thank_you_email(@form_entry, true).deliver_now
      expect(email.body).to include(@widget.settings["email_text"])
    end

    it "should send an email with a Facebook share link" do
      email = FormEntryMailer.thank_you_email(@form_entry, true).deliver_now
      expect(email.body).to include(@mobilization.facebook_share_url)
    end

    it "should send an email with a Twitter share link" do
      email = FormEntryMailer.thank_you_email(@form_entry, true).deliver_now
      expect(email.body).to include(@mobilization.twitter_share_url)
    end
  end
end
