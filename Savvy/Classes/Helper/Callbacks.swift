//
//  Callbacks.swift
//  Savvy iOS
//
//  Created by Ryan Cohen on 2/27/18.
//

import Foundation

open class Callbacks {

    /// Returns an array of `CryptoCurrency` objects and/or an `Error`
    public typealias GetCurrencies = (_ currencies: [CryptoCurrency]?, _ error: Error?) -> Void

    /// Returns an array of `Rate` objects and/or an `Error`
    public typealias GetMarketRates = (_ rate: [MarketRate]?, _ error: Error?) -> Void

    /// Returns a `Rate` object and/or an `Error`
    public typealias GetMarketRateSingle = (_ rate: MarketRate?, _ error: Error?) -> Void

    /// Returns a `PaymentRequest` objects and/or an `Error`
    public typealias GetPaymentRequest = (_ request: PaymentRequest?, _ error: Error?) -> Void

    /// Returns a `UIImage` representation of a payment request QR code
    public typealias GetPaymentRequestQR = (_ image: UIImage?) -> Void
}
