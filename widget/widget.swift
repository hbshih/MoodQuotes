//
//  widget.swift
//  widget
//
//  Created by Ben on 2020/11/19.
//

import WidgetKit
import SwiftUI
import Intents
import Foundation
import Firebase
import FirebaseUI

struct Provider: TimelineProvider{
    
    func placeholder(in context: Context) -> QuoteEntry {
        print("Widget got loaded")
        return (QuoteEntry(date: Date(), quote: Quote(quote: "asdf", author: "adsf"), flowerImage: UIImage(named: "default_flower")!, flowerName: "asfd"))
    }
    
    
    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        
        Analytics.logEvent("widget_got_installed", parameters: nil)
        
        print("Widget got loaded")
        let quote = (QuoteEntry(date: Date(), quote: Quote(quote: "活在當下 不求永生\n活得狂野 擁抱生命", author: "拉娜·德芮"), flowerImage: UIImage(named: "default_flower")!, flowerName: "滿天星"))
        completion(quote)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        
        print("Widget got loaded")
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        print("Widget Refreshing")
        
        if (UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")) == nil || SyncAppQuotes().checkIfUpdate()
            {
            
            DispatchQueue.main.async {
                firebaseService().getQuoteApiResponse {(result) in
                    let quoteInfo: [Quote]
                    if case .success(let fetchedData) = result {
                        quoteInfo = fetchedData
                        
                        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(quoteInfo.first!.quote, forKey: "Quote")
                        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(quoteInfo.first!.author, forKey: "Author")
                        
                        //downloadFlowerImage()
                        

                        
                        flowerHandler().getFlowerImageURL { (name, image_url) in
                            DispatchQueue.main.async { [self] in
                                

                                // Get a reference to the storage service using the default Firebase App
                                let storage = Storage.storage()

                                // Create a storage reference from our storage service
                                let storageRef = storage.reference()
                                
                                var imageView = UIImageView(image: UIImage(named: "default_flower"))
                                
                                print("get url \(image_url)")
                                // Reference to an image file in Firebase Storage
                                 let reference = storageRef.child("flowers/\(image_url).png")

                                // Placeholder image
                                let placeholderImage = UIImage(named: "placeholder.jpg")
                                
                                // Load the image using SDWebImage
                                imageView.sd_setImage(with: reference, placeholderImage: placeholderImage) { (image, error, cache, ref) in
                                    var flowerImage: UIImage
                                    var flowerName: String
                                    if error != nil
                                    {
                                        print("unable to load new image \(error)")
                                        flowerHandler().storeImage(image: UIImage(named: "default_flower")!, forKey: "FlowerImage", withStorageType: .userDefaults)
                                        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set("滿天星", forKey: "FlowerName")
                                        flowerName = "滿天星"
                                        flowerImage = UIImage(named: "default_flower")!
                                    }else
                                    {
                                        flowerHandler().storeImage(image: image!, forKey: "FlowerImage", withStorageType: .userDefaults)
                                        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(name, forKey: "FlowerName")
                                        flowerName = name
                                        flowerImage = image!
                                    }
                                    
                                    DispatchQueue.main.async {
                                        let entry = QuoteEntry(date: Date(), quote: quoteInfo.first!, flowerImage: flowerImage, flowerName: flowerName)
                                     //   (date: Date(), quote: quoteInfo.first!)
                                        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                                        WidgetCenter.shared.reloadAllTimelines()
                                        
                                        let content = UNMutableNotificationContent()
                                        content.title = "每天都更喜歡自己一點"
                                        content.body = "\(quoteInfo.first?.quote ?? "語錄更新了！打開來看看今天給你的話是什麼吧！")\n—\(quoteInfo.first?.author ?? "")"
                                        content.sound = UNNotificationSound.default

                                        let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                        let req  = UNNotificationRequest(identifier: "widget_update", content: content, trigger: tri)

                                        UNUserNotificationCenter.current().add(req) { (error) in
                                            print("error\(error )")
                                            
                                        }
                                        
                                        completion(timeline)
                                    }
                                }
                            }
                        }
                        
                        
                    } else {
                        let errQuote = Quote(quote: "App當機拉", author: "By Me")
                        quoteInfo = [errQuote,errQuote]
                    }
                }
            }
            }else
        {
            if let notificationDate = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.object(forKey: "updateTime") as? Date
            {
                print("Remain Local, the update time is \(notificationDate)")
            }
            print("load from local")
            let Q: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")!
            let A: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Author")!
            let FlowerImage: UIImage = flowerHandler().retrieveImage(forKey: "FlowerImage", inStorageType: .userDefaults)!
            let FlowerName: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "FlowerName")!
            let entry = QuoteEntry(date: Date(), quote: Quote(quote: Q, author: A), flowerImage: FlowerImage, flowerName: FlowerName)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
        
        
    }
    
}

struct QuoteEntry: TimelineEntry{
    var date: Date
    let quote: Quote
    let flowerImage: UIImage
    let flowerName: String
}

struct Emojibook_WidgetEntryView: View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
  /*  var body: some View {
        GeegeeWidgetView(quote: entry.quote)
    }
    */
    @ViewBuilder
        var body: some View {
            
            switch family {
          /*  case .systemSmall:
                GeegeeWidgetView(quote: entry.quote, quoteSize: 18, authorSize: 12)*/
            case .systemMedium:
                GeegeeWidgetView(quote: entry.quote, flowerImage: entry.flowerImage, flowerName: entry.flowerName, quoteSize: 28, authorSize: 20)
         /*   case .systemLarge:
                GeegeeWidgetView(quote: entry.quote, quoteSize: 32, authorSize: 24)*/
            default:
                Text("Some other WidgetFamily in the future.")
            }

        }
}

@main
struct widget: Widget{
    private let kind = "widget"
    
    init() {
        FirebaseApp.configure()
    }
    
    var backgroundColor: UIColor{
        if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")?.colorForKey(key: "BackgroundColor")
        {
            print(color)
            return color
        }
        else
        {
            return UIColor.gray
        }
    }
    
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            Emojibook_WidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)    // << here !!
                       .background(Color(backgroundColor))
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("句句 每日語錄")
        .description("記得分享")
    }
    
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
