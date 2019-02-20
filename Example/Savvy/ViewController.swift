//
//  ViewController.swift
//  Savvy
//
//  Created by imryan on 02/20/2019.
//  Copyright (c) 2019 imryan. All rights reserved.
//

import UIKit
import Savvy

class ViewController: UIViewController {
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Savvy.shared.shouldUseTestNet = true
        Savvy.shared.setToken("tpub801c5d843605cb5f0e9b5e7ad64cc866")
        
//        Savvy.shared.getPaymentRequestQR(crypto: .ltc, amount: 1.0,
//                                         address: "tpub801c5d843605cb5f0e9b5e7ad64cc866",
//                                         message: "Gimme the money Sal", size: nil, completion: { (image) in
//            debugPrint(image)
//        })
        
//        Savvy.shared.getCurrencies { (currencies, error) in
//            currencies?.forEach({ (curr) in
//                debugPrint(curr.title)
//            })
//        }
//
//        Savvy.shared.getMarketRates(fiat: .usd) { (rates, error) in
//            debugPrint("[x] Rates:", rates)
//        }
//
        Savvy.shared.getSingleMarketRate(fiat: "usd", date: Date(), crypto: .ltc) { (rate, error) in
            debugPrint("[x] USD -> LTC =:", rate)
        }
//
//        Savvy.shared.createPaymentRequest(crypto: .ltc, callbackURL: "") { (request, error) in
//            debugPrint("[x] Request:", request)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
