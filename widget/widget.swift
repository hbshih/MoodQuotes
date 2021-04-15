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

struct Provider: TimelineProvider{
    
    func placeholder(in context: Context) -> QuoteEntry {
        print("Widget got loaded")
        return (QuoteEntry(date: Date(), quote: Quote(quote: "asdf", author: "adsf")))
    }
    
    
    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        
        Analytics.logEvent("widget_got_installed", parameters: nil)
        
        print("Widget got loaded")
        let quote = (QuoteEntry(date: Date(), quote: Quote(quote: "活在當下 不求永生\n活得狂野 擁抱生命", author: "拉娜·德芮")))
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
                        
                        
                        
                        DispatchQueue.main.async {
                            let entry = QuoteEntry(date: Date(), quote: quoteInfo.first!)
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
            
//            /*For Testing*/
//            let content = UNMutableNotificationContent()
//            content.title = "test notifaction"
//            content.body = "Widget is remain local data"
//            content.sound = UNNotificationSound.default
//
//            let tri = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//            let req  = UNNotificationRequest(identifier: "testidentifire", content: content, trigger: tri)
//
//            UNUserNotificationCenter.current().add(req) { (error) in
//                print("error\(error )")
//            }
//            /*Testing Ends*/
//            
            print("load from local")
            let Q: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote")!
            let A: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Author")!
            let entry = QuoteEntry(date: Date(), quote: Quote(quote: Q, author: A))
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
        
        
    }
}

struct QuoteEntry: TimelineEntry{
    var date: Date
    let quote: Quote
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
            case .systemSmall:
                GeegeeWidgetView(quote: entry.quote, quoteSize: 18, authorSize: 12)
            case .systemMedium:
                GeegeeWidgetView(quote: entry.quote, quoteSize: 28, authorSize: 20)
            case .systemLarge:
                GeegeeWidgetView(quote: entry.quote, quoteSize: 32, authorSize: 24)
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
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            Emojibook_WidgetEntryView(entry: entry)
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
