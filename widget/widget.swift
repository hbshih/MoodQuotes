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

struct Provider: TimelineProvider{
    func placeholder(in context: Context) -> QuoteEntry {
        return (QuoteEntry(date: Date(), quote: Quote(quote: "asdf", author: "adsf")))
    }
    
    
    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        let quote = (QuoteEntry(date: Date(), quote: Quote(quote: "你是我的劫後餘生", author: "1")))
        completion(quote)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        let quote = (QuoteEntry(date: Date(), quote: Quote(quote: "你是我的劫後餘生", author: "溫")))
        let timeline = Timeline(entries: [quote], policy: .never)
        completion(timeline)
    }
}

struct QuoteEntry: TimelineEntry{
    var date: Date
    let quote: Quote
}

struct PlaceholderView: View
{
    var body: some View{
        GeegeeWidgetView(quote: Quote(quote: "1", author: "3"))
    }
}

struct Emojibook_WidgetEntryView: View {
  var entry: Provider.Entry

  var body: some View {
    GeegeeWidgetView(quote: entry.quote)
  }
}

@main
struct widget: Widget{
    private let kind = "widget"
    
    public var body: some WidgetConfiguration {
      StaticConfiguration(
        kind: kind,
        provider: Provider()
      ) { entry in
        Emojibook_WidgetEntryView(entry: entry)
      }
      .configurationDisplayName("RW Tutorials")
      .description("See the latest video tutorials.")
    }
}
