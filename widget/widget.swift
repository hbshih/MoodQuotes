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
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        
        if SyncAppQuotes().checkIfUpdate()
        {
            DispatchQueue.main.async {
                firebaseService().getQuoteApiResponse {(result) in
                    
                    var flowerImage: UIImage?
                    var flowerName: String?
                    let quoteInfo: [Quote]
                    
                    if case .success(let fetchedData) = result {
                        quoteInfo = fetchedData
                        
                        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(quoteInfo.first!.quote, forKey: "Quote")
                        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(quoteInfo.first!.author, forKey: "Author")
                        
                        flowerHandler().getFlowerImageURL { (name, image_url) in
                            DispatchQueue.main.async { [self] in
                                
                                
                                let storage = Storage.storage()
                                let storageRef = storage.reference().child("flowers/\(image_url).png")
                                storageRef.downloadURL { (url, error) in
                                    if let url = url, let imageData = try? Data(contentsOf: url),
                                       let uiImage = UIImage(data: imageData) {
                                        
                                        print("downloaded \(imageData)")
                                        flowerImage = uiImage
                                        
                                        flowerHandler().storeImage(image: uiImage, forKey: "FlowerImage", withStorageType: .userDefaults)
                                        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(name, forKey: "FlowerName")
                                        
                                    }
                                    else {
                                        // Image("placeholder-image")
                                    }
                                    
                                    let entry = QuoteEntry(date: Date(), quote: quoteInfo.first!, flowerImage: (flowerImage ?? UIImage(named: "default_flower"))!, flowerName: flowerName ?? "滿天星")
                                    
                                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                                    
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
            let Q: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote") ?? "星星發亮是為了讓每一個人有一天都能找到屬於自己的星星"
            let A: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Author") ?? "小王子"
            
            var FlowerImage: UIImage = UIImage(named: "default_flower")!
            var FlowerName: String
            
            FlowerImage = flowerHandler().retrieveImage(forKey: "FlowerImage", inStorageType: .userDefaults) ?? UIImage(named: "default_flower")!
            FlowerName = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "FlowerName") ?? "滿天星"
            let entry = QuoteEntry(date: Date(), quote: Quote(quote: Q, author: A), flowerImage: FlowerImage, flowerName: FlowerName)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
        
        
    }
    
    func downloadFlowerImage()
    {
    }
    
    
    
}

struct NetworkImage: View {
    
    let url: URL?
    
    var body: some View {
        
        Group {
            if let url = url, let imageData = try? Data(contentsOf: url),
               let uiImage = UIImage(data: imageData) {
                
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            else {
                Image("placeholder-image")
            }
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
            GeegeeWidgetView(date: entry.date ,quote: entry.quote, flowerImage: entry.flowerImage, flowerName: entry.flowerName, quoteSize: 20, authorSize: 14)
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

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
