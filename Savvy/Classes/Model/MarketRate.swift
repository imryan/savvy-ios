//
//  MarketRate.swift
//  Savvy iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation

public struct MarketRate: Codable {
    
    // MARK: - Attributes
    
    public var name: String?
    public let poloniex: Double?
    public let hitbtc: Double?
    public let bittrex: Double?
    public let bitfinex: Double?
    public let messari: Double?
    public let mid: Double?
    
    private enum CodingKeys: CodingKey {
        case name
        case poloniex
        case hitbtc
        case bittrex
        case bitfinex
        case messari
        case mid
    }
}
