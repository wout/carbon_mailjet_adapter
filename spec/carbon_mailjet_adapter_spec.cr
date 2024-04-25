require "./spec_helper"

describe Carbon::MailjetAdapter do
  describe ".deliver_now" do
    it "delivers the email successfully" do
      WebMock.stub(:post, "https://api.mailjet.com/v3.1/send")
        .with(body: fixture_string("success-body.json"))
        .to_return(body: fixture_string("success-response.json"))

      send_email(
        text_body: "text template",
        to: [Carbon::Address.new("w@zwartopwit.be")]
      ).status.should eq("success")
    end

    it "delivers emails with reply_to set" do
      WebMock.stub(:post, "https://api.mailjet.com/v3.1/send")
        .with(body: fixture_string("reply-to-body.json"))
        .to_return(body: fixture_string("success-response.json"))

      send_email(
        text_body: "text template",
        to: [Carbon::Address.new("w@zwartopwit.be")],
        headers: {"Reply-To" => "noreply@zwartopwit.be"}
      ).status.should eq("success")
    end
  end
end

private def params_for(**email_attrs)
  email = FakeEmail.new(**email_attrs)
  Carbon::MailjetAdapter::Email.new(email).params
end

private def send_email(**email_attrs)
  prepare_adapter.deliver_now(prepare_email(**email_attrs))
end

private def prepare_adapter
  Carbon::MailjetAdapter.new
end

private def prepare_email(**email_attrs)
  FakeEmail.new(**email_attrs)
end
