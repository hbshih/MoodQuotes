//
//  flowerHandler.swift
//  句句
//
//  Created by Ben on 2021/4/16.
//

import Foundation
import UIKit
import Firebase
import SDWebImageSwiftUI
import SDWebImage


struct flowerHandler{
    
    func countFirebaseRows(completion: @escaping ((_ count: Int) -> Void))
    {
        var count = 0
        Database.database().reference().child("Flower").observe(DataEventType.value) { (snapshot) in
            count = Int(snapshot.childrenCount)
            completion(count)
        }
    }
    
    func getFlowerImageURL(completion: @escaping ((_ name: String, _ imageurl: String) -> Void)) {
        
        var numberOfImages = 0
        
        countFirebaseRows { (count) in
            numberOfImages = count
            var randomImageNumber = Int.random(in: 1..<numberOfImages+1)
            
            if let url = URL(string: "https://geegee-a5bfd.firebaseio.com/Flower/\(randomImageNumber).json") {
               URLSession.shared.dataTask(with: url) { data, response, error in
                  if let data = data {
                      do {
                         let res = try JSONDecoder().decode(Response.self, from: data)
                        print(res.name)
                        print(res.fileName)
                        completion(res.name, res.fileName)
                      } catch let error {
                        print(error)
                      }
                   }
               }.resume()
            }
        }
    }
}

extension String
{
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
}

struct Response: Codable { // or Decodable
    let name: String
    let fileName: String
}
