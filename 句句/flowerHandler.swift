//
//  flowerHandler.swift
//  句句
//
//  Created by Ben on 2021/4/16.
//

import Foundation
import UIKit
import Firebase


struct flowerHandler{
    
    let numberOfImages = 35
    
    func getFlowerOfTheDay() 
    {
        
        let url = URL(string: "https://geegee-a5bfd.firebaseio.com/Flower/1/url.json")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else
            {
                return
            }
            print("get image url")
            //print(UR)
            //JSONDecoder().decode(URL(), from: data!)
            let str = String(decoding: data!, as: UTF8.self)
            print(str)
            //completion(.success(self.getQuoteResponse(fromData: data!)))
        }.resume()
    }
    
    func uploadFlowerImageToFirebase()
    {
        
        
    }
    
}
