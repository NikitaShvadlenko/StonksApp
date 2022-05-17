//
//  NetworkManager.swift
//  StonksApp
//
//  Created by Nikita Shvad on 17.05.2022.
//

import Foundation
import WidgetKit

class NetworkManager {
    func getCryptoData(completion: @escaping(SimpleEntry.CryptoData?) -> Void) {
        guard let url = URL(string: "https://api.blockchain.com/v3/exchange/tickers/BTC-USD") else { return completion(nil) }

        URLSession.shared.dataTask(with: url) { d, res, err in
            var result: SimpleEntry.CryptoData?
            if let data = d,
               let response = res as? HTTPURLResponse,
               response.statusCode == 200 {
                do {
                    result = try
                    JSONDecoder().decode(SimpleEntry.CryptoData.self, from: data)
                }
                catch {
                    print(error)
                }
            }
            return completion(result)
        }
        .resume()
    }
}

