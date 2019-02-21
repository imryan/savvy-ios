# Savvy

[![CI Status](https://img.shields.io/travis/imryan/Savvy.svg?style=flat)](https://travis-ci.org/imryan/Savvy)
[![Version](https://img.shields.io/cocoapods/v/Savvy.svg?style=flat)](https://cocoapods.org/pods/Savvy)
[![License](https://img.shields.io/cocoapods/l/Savvy.svg?style=flat)](https://cocoapods.org/pods/Savvy)
[![Platform](https://img.shields.io/cocoapods/p/Savvy.svg?style=flat)](https://cocoapods.org/pods/Savvy)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![](https://i.imgur.com/ZJQGoBS.png)
![](https://i.imgur.com/iUOr9sR.png)

## Installation

Savvy is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Savvy'
```

## Usage

#### Set Savvy API key
```swift
Savvy.shared.setToken("your-api-key")
```

#### Enable test network
```swift
Savvy.shared.shouldUseTestNet = true
```

#### Get current market prices
```swift
Savvy.shared.getCurrencies(completion: { (currencies, error) in
    if let currencies = currencies, error == nil {
        // Array of currency. Nice
    }
})
```

#### Get market exchange rates for all cryptocurrencies
```swift
Savvy.shared.getMarketRates(fiat: "usd") { (rates, error) in
    if let rates = rates, error == nil {
        // ...
    }
}
```

#### Get single market exchange rate for cryptocurrency
```swift
Savvy.shared.getSingleMarketRate(fiat: "usd", crypto: .btc) { (rate, error) in
    if let rate = rate, error == nil {
        // ...
    }
}
```

#### Create payment request in given cryptocurrency
```swift
Savvy.shared.createPaymentRequest(crypto: .btc, callbackURL: "http://some.site/") { (request, error) in
    if let request = request, error == nil {
        // ...
    }
}
```

#### Create payment request as QR code image
```swift
Savvy.shared.getPaymentRequestQR(crypto: .btc, amount: 1.0, address: "1F1tAaz5x1HUXrCNLbtMDqcw6o5GNn4xqX", message: "Free money", size: nil) { (image) in
    if let image = image {
        // QR code image containing a payment request
    }
}
```

## Requirements

* Alamofire
* Quick/Nimble (to run tests only)

## Author

Ryan Cohen, notryancohen@gmail.com

## License

Savvy is available under the MIT license. See the LICENSE file for more info.
