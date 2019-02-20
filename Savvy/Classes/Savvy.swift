//
//  Savvy.swift
//  Savvy iOS
//
//  Created by Ryan Cohen on 02/24/2018.
//  Copyright (c) 2018 Ryan Cohen. All rights reserved.
//

open class Savvy {
    
    // MARK: - Currencies
    
    public enum SavvyCryptoCurrencyType {
        case btc
        case bch
        case etc
        case eth
        case ltc
        case btg
        case dash
        case erc20(symbol: String)
        
        var rawValue: String {
            switch self {
            case .btc:
                return "btc"
            case .bch:
                return "bch"
            case .etc:
                return "etc"
            case .eth:
                return "eth"
            case .ltc:
                return "ltc"
            case .btg:
                return "btg"
            case .dash:
                return "dash"
            case .erc20(let symbol):
                return "erc20:\(symbol)"
            }
        }
    }
    
    // MARK: - Attributes
    
    /// Shared instance
    public static let shared = Savvy()
    
    /// Savvy API key
    public var token: String?
    
    /// Use testnet endpoints
    public var shouldUseTestNet: Bool = false {
        didSet {
            Networking.shouldUseTestNet = shouldUseTestNet
        }
    }
    
    // MARK: - Token
    
    open func setToken(_ token: String) {
        self.token = token
    }
    
    // MARK: - Currency
    
    /// Get list of current cryptocurrency prices
    /// API token required
    ///
    /// - Parameter completion: Array of `Currency` objects or an `Error`
    open func getCurrencies(completion: @escaping Callbacks.GetCurrencies) {
        Networking.getCurrencies(completion)
    }
    
    /// Get market exchange rates for all cryptocurrencies
    ///
    /// - Parameters:
    ///   - fiat: Fiat currency type (usd, eur, rub, etc)
    ///   - date: Optional parameter to get rate on specific date
    ///   - crypto: Cryptocurrency type
    ///   - completion: Array of `Rate` objects or an `Error`
    open func getMarketRates(fiat: String, date: Date? = nil, completion: @escaping Callbacks.GetMarketRates) {
        Networking.getMarketRates(fiat: fiat, date: date, completion: completion)
    }
    
    /// Get single market exchange rate for one cryptocurrency
    ///
    /// - Parameters:
    ///   - fiat: Fiat currency type (usd, eur, rub, etc)
    ///   - date: Optional parameter to get rate on specific date
    ///   - crypto: Cryptocurrency type
    ///   - completion: `Rate` object or an `Error`
    open func getSingleMarketRate(fiat: String, date: Date? = nil, crypto: SavvyCryptoCurrencyType,
                                  completion: @escaping Callbacks.GetMarketRateSingle) {
        
        Networking.getSingleMarketRate(fiat: fiat, date: date, crypto: crypto.rawValue, completion: completion)
    }
    
    /// Create payment request
    /// API token required
    ///
    /// - Parameters:
    ///   - crypto: Cryptocurrency to accept (eth, btc, bch, ltc, dash, btg, etc)
    ///   - callbackURL: Your server callback url (url encoded)
    ///   - completion: `PaymentRequest` object or an `Error`
    open func createPaymentRequest(crypto: SavvyCryptoCurrencyType,
                                   callbackURL: String, completion: @escaping Callbacks.GetPaymentRequest) {
        
        Networking.createPaymentRequest(crypto: crypto.rawValue, callbackURL: callbackURL, completion: completion)
    }
    
    /// Get QR code image for payment request
    ///
    /// - Parameters:
    ///   - crypto: Cryptocurrency to accept (eth, btc, bch, ltc, dash, btg, etc)
    ///   - amount: Amount you're asking to be paid
    ///   - address: The payout address for given crypto
    ///   - message: Optional message
    ///   - size: Optional image size. Default is 180x180
    ///   - completion: `UIImage` representation of QR code
    open func getPaymentRequestQR(crypto: SavvyCryptoCurrencyType, amount: Double, address: String,
                                  message: String?, size: CGSize?, completion: @escaping Callbacks.GetPaymentRequestQR) {
        
        Networking.getPaymentRequestQR(crypto: crypto.rawValue, amount: amount, address: address,
                                       message: message, size: size, completion: completion)
    }
}
