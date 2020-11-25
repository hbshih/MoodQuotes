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
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date_today = dateFormatter.string(from: Date())
        
        print("today date")
        print(date_today)
        
        ref.child("Quote of the Day").child("\(date_today)").observe(.value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary
            {
                print(value)
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
    
   
    
    func getQuoteApiResponse(completion: @escaping (Result<[Quote], Error>) -> Void)
    {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date_today = dateFormatter.string(from: Date())
        
        let url = URL(string: "https://geegee-a5bfd.firebaseio.com/Quote%20of%20the%20Day/\(date_today).json")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else
            {
                completion(.failure(error!))
                return
            }
            print(data)
            completion(.success(self.getQuoteResponse(fromData: data!)))
        }.resume()
    }
    
    private func getQuoteResponse(fromData data: Data) -> [Quote] {
        
        print(data)
        
        let Data = try? JSONDecoder().decode(QuoteResponse.self, from: data)
        print(Data)
        
        
        
        if let quoteD = Data{
            return [Quote(quote: quoteD.Quote, author: quoteD.Author)]
        }
        
        return [Quote(quote: "Erro", author: "Error")]
    }
    
}

struct QuoteResponse: Codable {
    let Quote: String
    let Author: String
}
