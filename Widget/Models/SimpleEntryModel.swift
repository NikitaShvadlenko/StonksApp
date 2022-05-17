//
//  SimpleEntryModel.swift
//  StonksAppWidgetExtension
//
//  Created by Nikita Shvad on 17.05.2022.
//

import Foundation
import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    var data: CryptoData
    var error: Bool

    enum DifferenceMode: String {
        case up = "up",
             down = "down",
             error = "error"
    }

    var differenceMode: DifferenceMode {
        if error || data.difference == 0.0 {
            return .error
        } else if data.difference > 0 {
            return .up
        } else {
            return .down
        }
    }
}

extension SimpleEntry {
    struct CryptoData: Decodable {
        let price_24h: Double
        let volume_24h: Double
        let last_trade_price: Double

        var difference: Double {
            price_24h - last_trade_price
        }

        static let previewData = CryptoData(
            price_24h: 34765.875438,
            volume_24h: 61.788,
            last_trade_price: 30025.22321)

        static let error = CryptoData(
            price_24h: 0,
            volume_24h: 0,
            last_trade_price: 0)
    }
}
