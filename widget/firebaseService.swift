//
//  firebaseService.swift
//  句句
//
//  Created by Ben on 2020/11/20.
//

import Foundation

import SwiftUI
import Firebase

class firebaseService {
    
    let ref = Database.database().reference()
    
    func getQuoteOfTheDay(completion: @escaping (Result<[Quote], Error>) -> Void) {
        
        ref.child("Quote of the Day").observe(.value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary
            {
                if let quote = value["Quote"] as? String
                {
                    if let author = value["Author"] as? String
                    {
                        let data = Quote(quote: quote, author: author)
                        completion(.success([data]))
                    }
                }
            }else
            {
                completion(.failure(Error.self as! Error))
            }
        }
    }
}
