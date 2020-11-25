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
        return (QuoteEntry(date: Date(), quote: Quote(quote: "asdf", author: "adsf")))
    }
    
    
    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        let quote = (QuoteEntry(date: Date(), quote: Quote(quote: "活在當下 不求永生\n活得狂野 擁抱生命", author: "拉娜·德芮")))
        completion(quote)
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        
     /*   WeatherSevice().getWeather { (result) in
            let weatherInfo: [Weather]
            
            if case .success(let fetchedData) = result {
                weatherInfo = fetchedData
            } else {
                let errWeather = Weather(name: "SF", temperature: 0, unit: "F", description: "Error getting weather info")
                weatherInfo = [errWeather, errWeather]
            }
            
            let entry = WeatherEntry(date: currentDate, weatherInfo: weatherInfo)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }*/
        
        firebaseService().getQuoteApiResponse { (result) in
            let quoteInfo: [Quote]
            if case .success(let fetchedData) = result {
                quoteInfo = fetchedData
            } else {
                let errQuote = Quote(quote: "App當機拉", author: "By Me")
                quoteInfo = [errQuote,errQuote]
            }
            
            let entry = QuoteEntry(date: Date(), quote: quoteInfo.first!)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
        
    }
}

struct QuoteEntry: TimelineEntry{
    var date: Date
    let quote: Quote
}
/*
struct PlaceholderView: View
{
    var body: some View{
        GeegeeWidgetView(quote: Quote(quote: "1", author: "3"), )
    }
}*/

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
        .configurationDisplayName("句句")
        .description("See the latest video tutorials.")
    }
    
}
