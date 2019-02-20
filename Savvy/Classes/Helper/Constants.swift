//
//  Constants.swift
//  Savvy iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation

public struct Constants {

    /// Latest API version
    private static let API_VERSION = "v3"

    /// API base URL
    static let API_BASE_URL = "https://api.savvy.io/\(API_VERSION)"

    /// API testnet base URL
    static let API_BASE_URL_TEST = "https://api.test.savvy.io/\(API_VERSION)"

    /// Members API base URL
    static let API_MEMBERS_BASE_URL = "https://member.savvy.io"

    /// Use regular base URL or testnet URL
    static var currentBaseURL: String {
        return Networking.shouldUseTestNet ? API_BASE_URL_TEST : API_BASE_URL
    }
}
