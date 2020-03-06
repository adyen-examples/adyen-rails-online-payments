# Adyen [online payment](https://docs.adyen.com/checkout) integration demos

This repository includes examples of PCI-compliant UI integrations for online payments with Adyen. Within this demo app, you'll find a simplified version of an e-commerce website, complete with commented code to highlight key features and concepts of Adyen's API. Check out the underlying code to see how you can integrate Adyen to give your shoppers the option to pay with their preferred payment methods, all in a seamless checkout experience.

![Card checkout demo](app/assets/images/cardcheckout.gif)

## Supported Integrations

**Ruby on Rails** demos of the following client-side integrations are currently available in this repository:

- [Drop-in](https://docs.adyen.com/checkout/drop-in-web)
- [Component](https://docs.adyen.com/checkout/components-web)
  - Card
  - iDEAL
  - Dotpay
  - giropay
  - SEPA Direct Debit
  - SOFORT

Each demo leverages Adyen's API Library for Ruby ([GitHub](https://github.com/Adyen/adyen-ruby-api-library) | [Docs](https://docs.adyen.com/development-resources/libraries#ruby)). See **app/models/checkout.rb** for payment methods.

## Requirements

Ruby 2.4.0+

## Installation

1. Clone this repo:

```
git clone https://github.com/adyen-examples/adyen-rails-online-payments.git
```

2. Navigate to the root directory and install dependencies:

```
bundle install
```

## Usage

1. Update **/config/local_env.yml** with your [API key](https://docs.adyen.com/user-management/how-to-get-the-api-key), [Origin Key](https://docs.adyen.com/user-management/how-to-get-an-origin-key), and merchant account name (all credentials are in string format):

```ruby
API_KEY: "YOUR_API_KEY_HERE"
MERCHANT_ACCOUNT: "YOUR_MERCHANT_ACCOUNT_HERE"
ORIGIN_KEY: "YOUR_ORIGIN_KEY_HERE"
```

2. Start the rails server (and run any migrations if prompted):

```
rails s
```

3. Visit [http://localhost:8080/](http://localhost:8080/) (**app/views/checkouts/index.html.erb**) to select an integration type.

To try out integrations with test card numbers and payment method details, see [Test card numbers](https://docs.adyen.com/development-resources/test-cards/test-card-numbers).

## Contributing

We commit all our new features directly into our GitHub repository. Feel free to request or suggest new features or code changes yourself as well!

## License

MIT license. For more information, see the **LICENSE** file in the root directory.
