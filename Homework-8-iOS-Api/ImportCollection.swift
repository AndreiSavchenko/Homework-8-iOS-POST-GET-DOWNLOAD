//
//  ImportCollection.swift
//  Homework-8-iOS-Api
//
//  Created by Alla on 1/16/19.
//  Copyright © 2019 AndreiSavchenko. All rights reserved.
//

import Foundation





//class ImportCollection {
//
//    static let importCol = ImportCollection()
//    var myJson: Any?
//
//    // MARK: Public methods
//
//    func importJson() {
//        let session = URLSession.shared
////        var dataTask: URLSessionDataTask?
//        guard let urlString = URL(string: "https://www.getpostman.com/collections/dc2a37036a53d3b5051b") else { return }
//
////        dataTask?.cancel()
//
//        session.dataTask(with: urlString) { (data, response, error) in
//            if let response = response {
//                print("RESPONSE")
//                print(response)
//            }
//
//            guard let data = data else { return }
//            print("DATA")
//            print(data)
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                print("JSON")
//                print(json)
//                self.myJson = json
//            } catch {
//                print("error")
//            }
//        }.resume()
//    }
//
//    func postJson() {
//        guard let urlString = URL(string: "https://www.getpostman.com/collections/dc2a37036a53d3b5051b") else { return }
//        let parametrs = myJson
//        var request = URLRequest(url: urlString)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        guard let httpBody = try? JSONSerialization.
//
//    }
//}
