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
        
        Savvy.shared.setToken("pub084d36ba99df44cc614c774810fbab78")
        Savvy.shared.getCurrencies { (currencies, error) in
            debugPrint("Currencies:", currencies)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
