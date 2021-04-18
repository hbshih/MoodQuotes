//
//  textDirectionModifier.swift
//  句句
//
//  Created by Ben on 2021/4/18.
//

import Foundation
import UIKit

extension String {
    // 文字列の範囲
    private var stringRange: NSRange {
        return NSMakeRange(0, self.utf16.count)
    }
    
    // 特定の正規表現を検索
    private func searchRegex(of pattern: String) -> NSTextCheckingResult? {
        do {
            let patternToSearch = try NSRegularExpression(pattern: pattern)
            return patternToSearch.firstMatch(in: self, range: stringRange)
        } catch { return nil }
    }
    
    // 特定の正規表現を置換
    private func replaceRegex(of pattern: String, with templete: String) -> String {
        do {
            let patternToReplace = try NSRegularExpression(pattern: pattern)
            return patternToReplace.stringByReplacingMatches(in: self, range: stringRange, withTemplate: templete)
        } catch { return self }
    }
    
    // ルビを生成
    func createRuby() -> NSMutableAttributedString {
        let textWithRuby = self
            // ルビ付文字(「｜紅玉《ルビー》」)を特定し文字列を分割
            .replaceRegex(of: "(｜.+?《.+?》)", with: ",$1,")
            .components(separatedBy: ",")
            // ルビ付文字のルビを設定
            .map { component -> NSAttributedString in
                // ベース文字(漢字など)とルビをそれぞれ取得
                guard let pair = component.searchRegex(of: "｜(.+?)《(.+?)》") else {
                    return NSAttributedString(string: component)
                }
                let component = component as NSString
                let baseText = component.substring(with: pair.range(at: 1))
                let rubyText = component.substring(with: pair.range(at: 2))
                
                // ルビの表示に関する設定
                let rubyAttribute: [CFString: Any] =  [
                    kCTRubyAnnotationSizeFactorAttributeName: 0.5,
                    kCTForegroundColorAttributeName: UIColor.darkGray
                ]
                let rubyAnnotation = CTRubyAnnotationCreateWithAttributes(
                    .auto, .auto, .before, rubyText as CFString, rubyAttribute as CFDictionary
                )
                
                
                return NSAttributedString(string: baseText, attributes: [kCTRubyAnnotationAttributeName as NSAttributedString.Key: rubyAnnotation])
            }
            // 分割されていた文字列を結合
            .reduce(NSMutableAttributedString()) { $0.append($1); return $0 }
        return textWithRuby
    }
}

public enum TextOrientation { //1
    case horizontal
    case vertical
}

class RubyLabel: UILabel {
    
    public var orientation:TextOrientation = .horizontal //2
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    // ルビを表示
    override func draw(_ rect: CGRect) {
        //super.draw(rect) //3
        
        
        // context allows you to manipulate the drawing context (i'm setup to draw or bail out)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        guard let string = self.text else { return }
        let attributed = NSMutableAttributedString(attributedString: string.createRuby()) //4
        
        let path = CGMutablePath()
        switch orientation { //5
        case .horizontal:
            context.textMatrix = CGAffineTransform.identity;
            context.translateBy(x: 0, y: self.bounds.size.height);
            context.scaleBy(x: 1.0, y: -1.0);
            path.addRect(self.bounds)
            attributed.addAttribute(NSAttributedString.Key.verticalGlyphForm, value: false, range: NSMakeRange(0, attributed.length))
        case .vertical:
            context.rotate(by: .pi / 2)
            context.scaleBy(x: 1.0, y: -1.0)
            //context.saveGState()
            //self.transform = CGAffineTransform(rotationAngle: .pi/2)
            path.addRect(CGRect(x: self.bounds.origin.y, y: self.bounds.origin.x, width: self.bounds.height, height: self.bounds.width))
            attributed.addAttribute(NSAttributedString.Key.verticalGlyphForm, value: true, range: NSMakeRange(0, attributed.length))
        }
        
        attributed.addAttributes([NSAttributedString.Key.font : self.font], range: NSMakeRange(0, attributed.length))
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attributed)
        
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0,attributed.length), path, nil)
        
        // Check need for truncate tail
        //6
        if (CTFrameGetVisibleStringRange(frame).length as Int) < attributed.length {
            // Required truncate
            let linesNS: NSArray  = CTFrameGetLines(frame)
            let linesAO: [AnyObject] = linesNS as [AnyObject]
            var lines: [CTLine] = linesAO as! [CTLine]
            
            let boundingBoxOfPath = path.boundingBoxOfPath
            
            let lastCTLine = lines.removeLast() //7
            
            let truncateString:CFAttributedString = CFAttributedStringCreate(nil, "\u{2026}" as CFString, CTFrameGetFrameAttributes(frame))
            let truncateToken:CTLine = CTLineCreateWithAttributedString(truncateString)
            
            let lineWidth = CTLineGetTypographicBounds(lastCTLine, nil, nil, nil)
            let tokenWidth = CTLineGetTypographicBounds(truncateToken, nil, nil, nil)
            let widthTruncationBegins = lineWidth - tokenWidth
            if let truncatedLine = CTLineCreateTruncatedLine(lastCTLine, widthTruncationBegins, .end, truncateToken) {
                lines.append(truncatedLine)
            }
            
            var lineOrigins = Array<CGPoint>(repeating: CGPoint.zero, count: lines.count)
            CTFrameGetLineOrigins(frame, CFRange(location: 0, length: lines.count), &lineOrigins)
            for (index, line) in lines.enumerated() {
                context.textPosition = CGPoint(x: lineOrigins[index].x + boundingBoxOfPath.origin.x, y:lineOrigins[index].y + boundingBoxOfPath.origin.y)
                CTLineDraw(line, context)
            }
        }
        else {
            // Not required truncate
            CTFrameDraw(frame, context)
        }
    }
    
    //8
    override var intrinsicContentSize: CGSize {
        let baseSize = super.intrinsicContentSize
        
        return CGSize(width: baseSize.width, height: baseSize.height * 1.0)
        
    }

}
