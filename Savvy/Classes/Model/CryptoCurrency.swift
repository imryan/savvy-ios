//
//  CryptoCurrency.swift
//  Savvy iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation

public struct CryptoCurrency: Codable {

    // MARK: - Attributes

    public let title: String?
    public let code: String?
    public let rate: Double?
    public let minimum: Double?
    public let maximum: Double?
    public let decimals: Int?
    public let maxConfirmations: Int?
    public let metamask: Bool?
    public let blockExplorer: String?
    public let contractAddress: String?

    private enum CodingKeys: String, CodingKey {
        case title
        case code
        case rate
        case minimum
        case maximum
        case decimals
        case maxConfirmations
        case metamask
        case blockExplorer
        case contractAddress = "contract_address"
    }
}
