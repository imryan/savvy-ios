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
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Attributes
    
    private var demoFiats: [String] = ["usd", "eur", "cad", "rub"]
    private var currentFiat: String = "usd"
    private var fiatBarButtonItem: UIBarButtonItem!
    private var paymentRequestQRImageView: UIImageView = UIImageView()
    private var currencies: [CryptoCurrency] = []
    private var rates: [MarketRate] = []
    
    // MARK: - Functions
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        fiatBarButtonItem = UIBarButtonItem(title: demoFiats[0].uppercased(), style: .plain,
                                            target: self, action: #selector(didChangeFiat))
        
        self.navigationItem.rightBarButtonItem = fiatBarButtonItem
        
        paymentRequestQRImageView.isHidden = true
        
        view.addSubview(paymentRequestQRImageView)
        paymentRequestQRImageView.translatesAutoresizingMaskIntoConstraints = false
        paymentRequestQRImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paymentRequestQRImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupSavvy() {
        Savvy.shared.shouldUseTestNet = true
        Savvy.shared.setToken("")
    }
    
    private func fetchCurrencies() {
        Savvy.shared.getCurrencies { (currencies, error) in
            if let currencies = currencies, error == nil {
                self.currencies = currencies
                self.reloadTable()
            }
        }
    }
    
    private func getMarketRates() {
        Savvy.shared.getMarketRates(fiat: currentFiat) { (rates, error) in
            if let rates = rates, error == nil {
                self.rates = rates
                self.reloadTable()
            }
        }
    }
    
    private func createPaymentRequest() {
        Savvy.shared.createPaymentRequest(crypto: .btc, callbackURL: "") { (request, error) in
            if let request = request {
                let message = "Created payment request to:\n\(request.address ?? "N/A")\nInvoice: #\(request.invoice ?? "N/A")."
                let alert = UIAlertController(title: "Payment Request", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func getPaymentRequestQR() {
        Savvy.shared.getPaymentRequestQR(crypto: .btc, amount: 1.0,
                                         address: "1MBZLCRWCYUH9X9H6rTFZ38KpNwCPxB5Yv",
                                         message: "Gimme the money Ton", size: nil, completion: { (image) in
                                            
                                            self.showPaymentQRImage(image)
        })
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadSections([0, 1], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    private func showPaymentQRImage(_ image: UIImage?) {
        paymentRequestQRImageView.image = image
        paymentRequestQRImageView.isHidden = false
    }
    
    // MARK: - Actions
    
    @objc private func didChangeFiat() {
        var index = demoFiats.firstIndex(of: currentFiat)!
        if index == demoFiats.count - 1 {
            index = 0
        } else {
            index += 1
        }
        
        currentFiat = demoFiats[index]
        fiatBarButtonItem.title = currentFiat.uppercased()
        
        getMarketRates()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !paymentRequestQRImageView.isHidden {
            paymentRequestQRImageView.isHidden = true
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSavvy()
        
        fetchCurrencies()
        getMarketRates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 || indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
            cell.selectionStyle = .none
            
            if indexPath.section == 0, indexPath.row < currencies.count {
                let currency = currencies[indexPath.row]
                cell.textLabel?.text = currency.title ?? "N/A"
                cell.detailTextLabel?.text = "$\(currency.rate ?? 0.0)"
            }
            else if indexPath.section == 1, indexPath.row < rates.count {
                let rate = rates[indexPath.row]
                cell.textLabel?.text = rate.name ?? "N/A"
                cell.detailTextLabel?.text = "\(rate.mid ?? 0.0)"
            }
            
            return cell
        }
        
        let selectableCell = tableView.dequeueReusableCell(withIdentifier: "SelectableCellId", for: indexPath)
        if indexPath.row == 0 {
            selectableCell.textLabel?.text = "Create Payment Request"
        }
        else {
            selectableCell.textLabel?.text = "Get Payment Request QR"
        }
        
        return selectableCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return currencies.count
        }
        else if section == 1 {
            return rates.count
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Cryptocurrencies"
        }
        else if section == 1 {
            return "Market Rates"
        }
        
        return "Payment Requests"
    }
}


// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                createPaymentRequest()
            }
            else {
                getPaymentRequestQR()
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
