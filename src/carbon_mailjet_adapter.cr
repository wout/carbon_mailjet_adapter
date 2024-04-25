require "http"
require "json"
require "carbon"
require "mailjet"

class Carbon::MailjetAdapter < Carbon::Adapter
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}

  def deliver_now(email : Carbon::Email)
    Carbon::MailjetAdapter::Email.new(email).deliver
  end

  class Email
    private getter email

    def initialize(@email : Carbon::Email)
    end

    def deliver
      Mailjet::SendV3_1.message(params)
    end

    def params
      {
        "To"          => to_mailjet_addresses(email.to),
        "Cc"          => to_mailjet_addresses(email.cc),
        "Bcc"         => to_mailjet_addresses(email.bcc),
        "Subject"     => email.subject,
        "From"        => from,
        "HTMLPart"    => email.html_body.to_s,
        "TextPart"    => email.text_body.to_s,
        "Attachments" => attachments,
        "Headers"     => email.headers,
      }.compact.reject { |_, value| value.empty? }
    end

    private def to_mailjet_addresses(addresses : Array(Carbon::Address))
      addresses.map do |carbon_address|
        {
          "Email" => carbon_address.address,
          "Name"  => carbon_address.name,
        }
      end
    end

    private def from
      {
        "Email" => email.from.address,
        "Name"  => email.from.name,
      }
    end

    private def attachments
      Array(Hash(String, String)).new.tap do |files|
        email.attachments.map do |attachment|
          files.push(attachment_file(attachment))
        end
      end
    end

    private def attachment_file(attachment)
      {
        "Base64Content" => Base64.encode(attachment_content(attachment)),
        "ContentType"   => attachment[:mime_type].to_s,
        "Filename"      => attachment[:file_name].to_s,
      }
    end

    private def attachment_content(attachment)
      case attachment
      in AttachFile, ResourceFile then File.read(attachment[:file_path])
      in AttachIO, ResourceIO     then attachment[:io].to_s
      end
    end
  end
end
