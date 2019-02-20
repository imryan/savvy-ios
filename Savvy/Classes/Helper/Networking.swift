//
//  Networking.swift
//  Savvy iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation
import Alamofire

class Networking {

    // MARK: - Attributes

    static var shouldUseTestNet: Bool = false

    // MARK: - Requests

    static func getCurrencies(_ completion: @escaping Callbacks.GetCurrencies) {
        guard tokenExists() else {
            completion(nil, error("Missing API key.", code: -1))
            return
        }

        get("currencies") { (dict, error) in
            guard let dict = dict as? [String: [String: Any]], error == nil else {
                completion(nil, error)
                return
            }

            var currencies: [CryptoCurrency] = []
            dict.forEach({ (key, val) in
                if let currencyData = try? JSONSerialization.data(withJSONObject: val, options: []) {
                    if let currency = try? JSONDecoder().decode(CryptoCurrency.self, from: currencyData) {
                        currencies.append(currency)
                    }
                }
            })

            completion(currencies, nil)
        }
    }

    static func getMarketRates(fiat: String, date: Date? = nil, completion: @escaping Callbacks.GetMarketRates) {
        var url = "exchange/\(fiat)/rate"
        if let date = date {
            url.append("?time=\(Int(date.timeIntervalSince1970))")
        }

        get(url, needsAuth: false) { (dict, error) in
            guard let dict = dict as? [String: [String: Any]], error == nil else {
                completion(nil, error)
                return
            }

            var rates: [MarketRate] = []
            dict.forEach({ (key, val) in
                if let rateData = try? JSONSerialization.data(withJSONObject: val, options: []) {
                    if var rate = try? JSONDecoder().decode(MarketRate.self, from: rateData) {
                        rate.name = key
                        rates.append(rate)
                    }
                }
            })

            completion(rates, nil)
        }
    }

    static func getSingleMarketRate(fiat: String, date: Date? = nil, crypto: String, completion: @escaping Callbacks.GetMarketRateSingle) {
        var url = "\(crypto)/exchange/\(fiat)/rate"
        if let date = date {
            url.append("?time=\(Int(date.timeIntervalSince1970))")
        }

        get(url, needsAuth: false) { (dict, error) in
            guard let dict = dict, error == nil else {
                completion(nil, error)
                return
            }

            if let rateData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                if var rate = try? JSONDecoder().decode(MarketRate.self, from: rateData) {
                    rate.name = crypto
                    completion(rate, nil)
                    return
                }
            }

            completion(nil, error)
        }
    }

    static func createPaymentRequest(crypto: String, callbackURL: String, completion: @escaping Callbacks.GetPaymentRequest) {
        if !tokenExists() {
            completion(nil, error("Missing API key.", code: -1))
            return
        }

        get("\(crypto)/payment/\(callbackURL)") { (dict, error) in
            guard let dict = dict as? [String: String], error == nil else {
                completion(nil, error)
                return
            }

            if let requestData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                if let request = try? JSONDecoder().decode(PaymentRequest.self, from: requestData) {
                    completion(request, nil)
                    return
                }
            }

            completion(nil, error)
        }
    }

    // TODO: From paymentRequest object
    static func getPaymentRequestQR(crypto: String, amount: Double, address: String, message: String?, size: CGSize?,
        completion: @escaping Callbacks.GetPaymentRequestQR) {

        guard !address.isEmpty else {
            completion(nil)
            return
        }

        let size = (size != nil) ? "\(String(describing: size!.width))x\(String(describing: size!.height))" : "180x180"

        var paymentURL = "\(crypto):\(address)?amount=\(amount)"
        if var message = message {
            message = message.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
            paymentURL.append("&message=\(message)")
        }

        let url = "https://chart.googleapis.com/chart?chs=\(size)&cht=qr&chl=\(paymentURL)"
        Alamofire.request(url, method: .get).response { (response) in
            if let data = response.data {
                if let image = UIImage(data: data) {
                    completion(image)
                    return
                }
            }

            completion(nil)
        }
    }
}

// MARK: - Request Helpers

extension Networking {

    static func get(_ endpoint: String, needsAuth: Bool = true, completion: @escaping (_ data: Any?, _ error: Error?) -> ()) {
        var url = "\(Constants.currentBaseURL)/\(endpoint)"

        if tokenExists() && needsAuth {
            url.append("?token=\(Savvy.shared.token!)")
        }
        
        Alamofire.request(url, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                guard let json = json as? [String: Any] else {
                    completion(nil, error("Unable to parse response.", code: -3))
                    return
                }

                // Check for errors in response
                if let error = error(inJSON: json) {
                    completion(nil, error)
                }
                else if let dataContents = json["data"] as? [String: Any] {
                    completion(dataContents, nil)
                }
            case .failure(let error):
                completion(nil, error)
                debugPrint("\(NSStringFromSelector(#function)) error: \(error)")
            }
        }
    }

    // MARK: - Helpers

    static func tokenExists() -> Bool {
        if let token = Savvy.shared.token {
            if token.isEmpty == false {
                return true
            }
        }

        return false
    }

    static func error(inJSON json: [String: Any]) -> Error? {
        if let success = json["success"] as? Bool {
            if success == false {
                if let errors = json["errors"] as? [[String: Any]] {
                    if let message = errors.first?["message"] as? String {
                        return error(message, code: -2)
                    }
                }
            }
        }

        return nil
    }

    static func error(_ error: String, code: Int) -> NSError {
        return NSError(domain: "io.savvy.Savvy", code: code, userInfo: [NSLocalizedDescriptionKey: error])
    }
}
