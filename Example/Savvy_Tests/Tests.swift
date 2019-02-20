@testable import Savvy

import Quick
import Nimble

class Tests: QuickSpec {
    
    override func spec() {
        beforeEach {
            Savvy.shared.shouldUseTestNet = true
            Savvy.shared.setToken("tpub801c5d843605cb5f0e9b5e7ad64cc866")
        }
        
        describe("fetch currencies") {
            it("should get an array of CryptoCurrency objects with attributes.") {
                waitUntil(action: { (done) in
                    Savvy.shared.getCurrencies { (currencies, error) in
                        if let currencies = currencies, error == nil {
                            for currency in currencies {
                                expect(currency.title).toNot(beNil())
                                expect(currency.code).toNot(beNil())
                                expect(currency.rate).to(beGreaterThan(0.0))
                            }
                            done()
                        }
                    }
                })
            }
            
            describe("fetch market rates") {
                it("should get an array of Rate objects with attributes.") {
                    waitUntil(action: { (done) in
                        Savvy.shared.getMarketRates(fiat: "usd") { (rates, error) in
                            if let rates = rates, error == nil {
                                for rate in rates {
                                    expect(rate.name).toNot(beNil())
                                    expect(rate.mid).to(beGreaterThan(0.0))
                                }
                                done()
                            }
                        }
                    })
                }
            }
            
            describe("fetch single market rate") {
                it("should get an array of Rate objects with attributes.") {
                    waitUntil(action: { (done) in
                        Savvy.shared.getSingleMarketRate(fiat: "usd", crypto: .btc, completion: { (rate, error) in
                            if let rate = rate, error == nil {
                                //expect(rate.poloniex).toNot(beNil())
                                expect(rate.mid).to(beGreaterThan(0.0))
                                done()
                            }
                        })
                    })
                }
            }
            
            describe("create a payment request") {
                it("should create a payment request") {
                    waitUntil(action: { (done) in
                        Savvy.shared.createPaymentRequest(crypto: .btc, callbackURL: "", completion: { (request, error) in
                            if let request = request, error == nil {
                                expect(request.invoice).toNot(beNil())
                                expect(request.address).toNot(beNil())
                                done()
                            }
                        })
                    })
                }
            }
        }
    }
}
