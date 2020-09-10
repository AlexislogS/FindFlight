//
//  DataManager.swift
//  FindFlight
//
//  Created by Alex Yatsenko on 17.07.2020.
//  Copyright © 2020 Alexislog's Production. All rights reserved.
//

import Foundation

final class DataManager {
    
    func readData(completion: @escaping (_ result: Result<[String], Error>) -> Void) {
        guard let url = URL(string: URLs.routesURL) else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let text = try String(contentsOf: url)
                var routes = text.components(separatedBy: "\n")
                routes.removeLast()
                DispatchQueue.main.async {
                    completion(.success(routes))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
