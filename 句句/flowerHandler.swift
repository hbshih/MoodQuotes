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
    
    func getImageFromServerById(imageId: String, completion: @escaping ((_ name: String, _ imageurl: String) -> Void)) {
        
        var numberOfImages = 0
        
        countFirebaseRows { (count) in
            numberOfImages = count
            
            var randomImageNumber = Int.random(in: 1..<numberOfImages+1)
            
            if let url = URL(string: "https://geegee-a5bfd.firebaseio.com/Flower/\(randomImageNumber).json") {
               URLSession.shared.dataTask(with: url) { data, response, error in
                  if let data = data {
                      do {
                        print("url session ehre")
                         let res = try JSONDecoder().decode(Response.self, from: data)
                        print(res.name)
                        print(res.fileName)
                        completion(res.name, res.fileName)
                      } catch let error {
                        print("url session ehre")
                         print(error)
                      }
                   }
               }.resume()
            }
            
        }
   //     print(numberOfImage)
        

        /*
        DispatchQueue.main.async {
            let url = URL(string: "https://geegee-a5bfd.firebaseio.com/Flower/2/url.json")!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                let str = String(data: data!, encoding: String.Encoding.utf8) as String?
                print(str)
                completion(str!)
            }
            task.resume()
        }

        */
    }
    /*
    func getFlowerOfTheDay(completion: ((_ image: UIImage?) -> Void))
    {
        
        
        let url = URL(string: "https://geegee-a5bfd.firebaseio.com/Flower/2/url.json")!
        var str = ""
       
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else
            {
               // completion()
                return
            }
            print(data)
            str = String(decoding: data!, as: UTF8.self)
            print(str)
            DispatchQueue.main.async(execute: {
            
                let ImageOfFlower = UIImageView()
                
                ImageOfFlower.sd_setImage(with: URL(string: "https://www.lifewire.com/thmb/8Bw6WabD8jLjw537MHA-F1LTOAw=/960x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/png-file-photos-app-5b75972f46e0fb002c692c03.png")) { (fetchedImage, error, cache, urls) in
                    if (error != nil)
                    {
                        completion(UIImage(named: "example_plant")!)
                       // return UIImage(named: "example_plant")
                    }else
                    {
                        completion(fetchedImage!)
                    }
                }
            })
        }.resume()
    }
    /*    private func getImage(url: String){
        
        
        let ImageOfFlower = UIImageView()
        
        ImageOfFlower.sd_setImage(with: URL(string: "https://www.lifewire.com/thmb/8Bw6WabD8jLjw537MHA-F1LTOAw=/960x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/png-file-photos-app-5b75972f46e0fb002c692c03.png")) { (fetchedImage, error, cache, urls) in
            if (error != nil)
            {
                return UIImage(named: "example_plant")
            }else
            {
                return fetchedImage
            }
        }
    }*/
    
    
    func uploadFlowerImageToFirebase()
    {
        
        
    }
    */
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
