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
import StoreKit


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
    
    func storeImage(image: UIImage,
                        forKey key: String,
                        withStorageType storageType: StorageType) {
        if let pngRepresentation = image.pngData() {
            switch storageType {
            case .fileSystem:
                if let filePath = filePath(forKey: key) {
                    do  {
                        try pngRepresentation.write(to: filePath,
                                                    options: .atomic)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
            case .userDefaults:
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(pngRepresentation,
                                            forKey: key)
            }
        }
    }
    
    func retrieveImage(forKey key: String,
                                inStorageType storageType: StorageType) -> UIImage? {
        switch storageType {
        case .fileSystem:
            if let filePath = self.filePath(forKey: key),
                let fileData = FileManager.default.contents(atPath: filePath.path),
                let image = UIImage(data: fileData) {
                return image
            }
        case .userDefaults:
            if let imageData = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: key) as? Data,
                let image = UIImage(data: imageData) {
                return image
            }
        }
        
        return nil
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
}

struct coloredflowerHandler{
    
    func countFirebaseRows(completion: @escaping ((_ count: Int) -> Void))
    {
        var count = 0
        Database.database().reference().child("Colored_Flower").observe(DataEventType.value) { (snapshot) in
            count = Int(snapshot.childrenCount)
            completion(count)
        }
    }
    
    func getFlowerImageURL(completion: @escaping ((_ name: String, _ imageurl: String, _ meaning: String) -> Void)) {
        
        var numberOfImages = 0
        
        countFirebaseRows { (count) in
            numberOfImages = count
            var randomImageNumber = Int.random(in: 1..<numberOfImages+1)
            
            if let url = URL(string: "https://geegee-a5bfd.firebaseio.com/Colored_Flower/2.json") {
               URLSession.shared.dataTask(with: url) { data, response, error in
                  if let data = data {
                      do {
                         let res = try JSONDecoder().decode(ResponseColored.self, from: data)
                        print(res.name)
                        print(res.fileName)
                          print(res.meaning)
                          completion(res.name, res.fileName, res.meaning)
                      } catch let error {
                        print(error)
                      }
                   }
               }.resume()
            }
        }
    }
    
    func storeImage(image: UIImage,
                        forKey key: String,
                        withStorageType storageType: StorageType) {
        if let pngRepresentation = image.pngData() {
            switch storageType {
            case .fileSystem:
                if let filePath = filePath(forKey: key) {
                    do  {
                        try pngRepresentation.write(to: filePath,
                                                    options: .atomic)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
            case .userDefaults:
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(pngRepresentation,
                                            forKey: key)
            }
        }
    }
    
    func retrieveImage(forKey key: String,
                                inStorageType storageType: StorageType) -> UIImage? {
        switch storageType {
        case .fileSystem:
            if let filePath = self.filePath(forKey: key),
                let fileData = FileManager.default.contents(atPath: filePath.path),
                let image = UIImage(data: fileData) {
                return image
            }
        case .userDefaults:
            if let imageData = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: key) as? Data,
                let image = UIImage(data: imageData) {
                return image
            }
        }
        
        return nil
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
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

struct ResponseColored: Codable { // or Decodable
    let name: String
    let fileName: String
    let meaning: String
}

struct FlowerImage{
    let image: UIImage
    let fileName: String
}

enum StorageType {
    case userDefaults
    case fileSystem
}
