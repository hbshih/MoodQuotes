//
//  WidgetGroup.swift
//  WidgetGroup
//
//  Created by Tihomir RAdeff on 3.10.20.
//

import WidgetKit
import SwiftUI
import Firebase
import FirebaseUI
import FirebaseAnalytics

struct LargeWidget_FullProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> LargeWidget_FullEntry {
        print("Widget got loaded")
        return (LargeWidget_FullEntry(date: Date(), quote: Quote(quote: "asdf", author: "adsf"), flowerImage: UIImage(named: "flower_10_babys breath_滿天星")!, flowerName: "asfd"))
    }
    
    
    func getSnapshot(in context: Context, completion: @escaping (LargeWidget_FullEntry) -> Void) {
        
    
        Analytics.logEvent("widget_got_installed", parameters: ["type": "largewidget_full"])
        print("Widget got loaded")
        let quote = (LargeWidget_FullEntry(date: Date(), quote: Quote(quote: "星星發亮是為了讓每一個人有一天都能找到屬於自己的星星", author: "小王子"), flowerImage: UIImage(named: "flower_10_babys breath_滿天星")!, flowerName: "滿天星"))
        completion(quote)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LargeWidget_FullEntry>) -> Void) {
        let currentDate = Date()
        var refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        var quoteInfo: [Quote]?
        
        if SyncAppQuotes().checkIfUpdate_widget()
        {
         print("update widget")
            
            DispatchQueue.main.async {
                let entry = LargeWidget_FullEntry(date: Date(), quote: Quote(quote: "點開查看今日給你的話吧", author: "點開查看"), flowerImage: UIImage(named: "noun_seeds_184642")!, flowerName: "我是種子")
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                flowerHandler().storeImage(image: UIImage(named: "noun_seeds_184642")!, forKey: "FlowerImage", withStorageType: .userDefaults)
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(entry.flowerName, forKey: "FlowerName")
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(entry.quote.quote, forKey: "Quote")
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(entry.quote.author, forKey: "Author")
                
                firebaseService().getQuoteApiResponse { (result) in
                    if case .success(let fetchedData) = result {
                        quoteInfo = fetchedData
                        
                        
                        // Push Notification
                        let content = UNMutableNotificationContent()
                        content.title = "看看屬於你今日的植物是什麼吧！"
                        content.body = "\(quoteInfo?.first?.quote ?? "語錄更新了！打開來看看今天給你的話是什麼吧！")\n—\(quoteInfo?.first?.author ?? "")"
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
        }else
        {
            print("keep local data")
            let Q: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Quote") ?? "星星發亮是為了讓每一個人有一天都能找到屬於自己的星星"
            let A: String = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "Author") ?? "小王子"
            
            var FlowerImage: UIImage = UIImage(named: "flower_10_babys breath_滿天星")!
            var FlowerName: String
            
            FlowerImage = flowerHandler().retrieveImage(forKey: "FlowerImage", inStorageType: .userDefaults) ?? UIImage(named: "flower_10_babys breath_滿天星")!
            FlowerName = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "FlowerName") ?? "滿天星"
            let entry = LargeWidget_FullEntry(date: Date(), quote: Quote(quote: Q, author: A), flowerImage: FlowerImage, flowerName: FlowerName)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
        
        
    }
}

struct LargeWidget_FullEntry: TimelineEntry {
    var date: Date
    let quote: Quote
    let flowerImage: UIImage
    let flowerName: String
}

struct LargeWidget_FullEntryView : View {
    //let emojiDetails: EmojiDetails
      
      let date: Date
      let quote: Quote
      let flowerImage: UIImage
      let flowerName: String
      let quoteSize: Double
      let authorSize: Double
      
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

      var body: some View {
          
      ZStack {
          if #available(iOS 14.0, *) {
              Color(backgroundColor).ignoresSafeArea(.all).edgesIgnoringSafeArea(.all)
          } else {
              // Fallback on earlier versions
          }
          // Widget Background Image
        //  Image(uiImage: #imageLiteral(resourceName: "Webp.net-compress-image-removebg-preview.png"))
          VStack(alignment: .leading, spacing: 64){
              
              HStack{
                  
                  HStack{
                      HStack
                      {
                          Text(date.getDateDayOnly).font(Display_Font(font_size: Int(24)).getFont()).fontWeight(.light).multilineTextAlignment(.leading
                          ).foregroundColor(.gray)
                          VStack(alignment: .leading)
                          {
                              Text(date.getFormattedDate).font(Display_Font(font_size: Int(14)).getFont()).multilineTextAlignment(.center).foregroundColor(.gray)
                              Text(date.getTWday).font(Display_Font(font_size: Int(14)).getFont()).multilineTextAlignment(.center).foregroundColor(.gray)
                          }
                      }
                      
                      //Text("今日心情").font(.system(size: 16.0)).fontWeight(.light).multilineTextAlignment(.center).foregroundColor(.gray)
                      
                  }
                  
              }
              
              Text(quote.quote).font(Display_Font(font_size: Int(20)).getFont()).fontWeight(.light).multilineTextAlignment(.leading).foregroundColor(.gray)
              
              Text(quote.author).font(Display_Font(font_size: Int(14)).getFont()).fontWeight(.light).multilineTextAlignment(.center).foregroundColor(.gray)
              
              
              
              /*
              
              HStack{
                  HStack{
                    Image(uiImage: flowerImage).resizable().frame(width: 100, height: 100, alignment: .center)
                      Text(flowerName).font(Display_Font(font_size: Int(12)).getFont()).multilineTextAlignment(.center).foregroundColor(.gray)
                      //Text(date.getTodayDate).font(.system(size: 8.0)).fontWeight(.light).multilineTextAlignment(.center).foregroundColor(.gray)
                  }
              }
              
              VStack{
                  VStack{
                      Text(quote.quote).font(Display_Font(font_size: Int(18)).getFont()).foregroundColor(.gray).multilineTextAlignment(.center).padding(.leading,8).padding(.trailing,8).minimumScaleFactor(0.5)
                      Text(quote.author)
                          .font(Display_Font(font_size: Int(12)).getFont())
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                          .foregroundColor(.gray)
                  }
              }
              
              */
          }

      }
      .padding(.vertical, 2.5).padding(.horizontal, 16)
      }
}

struct LargeWidget_Full: Widget {
    private let kind = "LargeWidget_Full"
    
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
            provider: LargeWidget_FullProvider()
        ) { entry in
            LargeWidget_FullEntryView(date: entry.date ,quote: entry.quote, flowerImage: entry.flowerImage, flowerName: entry.flowerName, quoteSize: 20, authorSize: 14)       .frame(maxWidth: .infinity, maxHeight: .infinity)    // << here !!
                .background(Color(backgroundColor))
        }
        .supportedFamilies([.systemLarge])
        .configurationDisplayName("佔滿你的頁面")
        .description("語錄、日期一次滿足")
    }
}

struct LargeWidget_Full_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
