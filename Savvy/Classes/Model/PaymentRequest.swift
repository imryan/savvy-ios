//
//  PaymentRequest.swift
//  Savvy iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation

public struct PaymentRequest: Codable {

    // MARK: - Attributes

    public let invoice: String?
    public let address: String?

    private enum CodingKeys: CodingKey {
        case invoice
        case address
    }
}
