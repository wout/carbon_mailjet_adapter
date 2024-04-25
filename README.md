# carbon_mailjet_adapter

Integration for Lucky's [Carbon](https://github.com/luckyframework/carbon) email library and [mailjet.cr](https://github.com/wout/mailjet.cr) to send emails via [Mailjet](https://www.mailjet.com/).

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  carbon_mailjet_adapter:
    github: wout/carbon_mailjet_adapter
```

2. Run `shards install`

## Usage

Include the shard:

```crystal
require "carbon_mailjet_adapter"
```

Configure [mailjet.cr](https://github.com/wout/mailjet.cr):

```crystal
Mailjet.configure do |settings|
  settings.api_key = "your-api-key"
  settings.secret_key = "your-secret-key"
  settings.default_from = "noreply@email.com"
end
```

And configure the adapter in your Lucky app:

```crystal
# config/email.cr
require "carbon_mailjet_adapter"

BaseEmail.configure do |settings|
  if LuckyEnv.production? || LuckyEnv.staging?
    settings.adapter = Carbon::MailjetAdapter.new
  elsif ...
    ...
  end
end
```

**Important:** For simplicity and predictability, this adapter will always send using Mailjet's v3.1 sending API, regardless of the Mailjet configuration in your project.

## Contributing

1. Fork it (<https://github.com/wout/carbon_mailjet_adapter/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'feat: add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Wout](https://github.com/wout) - creator and maintainer
