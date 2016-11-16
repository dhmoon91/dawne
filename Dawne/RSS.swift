//
//  RSS.swift
//  Dawne
//
//  Copyright © 2016 It's Too Early. All rights reserved.
//

import Foundation
import PySwiftyRegex

class RssRecord {
    
    var title: String
    var description: String
    var link: String
    var pubDate: String
    var imgLink: String
    var summary: String
    
    init(){
        self.title = ""
        self.description = ""
        self.link = ""
        self.pubDate = ""
        self.imgLink = ""
        self.summary = ""
    }
    
}

class RSSReader: NSObject, NSXMLParserDelegate {
    
    
    // xml parser
    var myParser: NSXMLParser = NSXMLParser()
    
    // rss records
    var rssRecordList : [RssRecord] = [RssRecord]()
    var rssRecord : RssRecord?
    var isTagFound = [ "item": false , "title":false, "pubDate": false ,"link":false, "description":false]
    
    func startParse(myURL: NSURL) {
        // fetch rss content from url
        self.myParser = NSXMLParser(contentsOfURL: myURL)!
        
        // set parser delegate
        self.myParser.delegate = self
        self.myParser.shouldResolveExternalEntities = false
        
        // start parsing
        self.myParser.parse()
    }
    
    func parserDidStartDocument(parser: NSXMLParser) {
        // start parsing
    }
    
    // element start detected
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "item" {
            self.isTagFound["item"] = true
            self.rssRecord = RssRecord()
            
        }else if elementName == "title" {
            self.isTagFound["title"] = true
            
        }else if elementName == "link" {
            self.isTagFound["link"] = true
            
        }else if elementName == "pubDate" {
            self.isTagFound["pubDate"] = true
        }else if elementName == "description" {
            self.isTagFound["description"] = true
        }
        
    }
    
    // characters received for some element
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        if isTagFound["title"] == true {
            self.rssRecord?.title += string
            
        }else if isTagFound["link"] == true {
            self.rssRecord?.link += string
            
        }else if isTagFound["pubDate"] == true {
            self.rssRecord?.pubDate += string
        }else if isTagFound["description"] == true {
            self.rssRecord?.description += string
        }
        
    }
    
    // element end detected
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            self.isTagFound["item"] = false
            self.rssRecordList.append(self.rssRecord!)
            
        }else if elementName == "title" {
            self.isTagFound["title"] = false
            
        }else if elementName == "link" {
            self.isTagFound["link"] = false
            
        }else if elementName == "pubDate" {
            self.isTagFound["pubDate"] = false
        }else if elementName == "description" {
            self.isTagFound["description"] = false
        }
    }
    
    // end parsing document
    func parserDidEndDocument(parser: NSXMLParser) {
        cleanDescriptions()
        NSNotificationCenter.defaultCenter().postNotificationName("RSSComplete", object: nil)
        print("finished parsing")
    }
    
    // if any error detected while parsing.
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        
        //error
    }
    
    func cleanDescriptions() {
        for item in self.rssRecordList {
            let rawDescription = item.description
            print(rawDescription)
            if let m = re.search("src='.*?'", rawDescription) {
                var result = re.sub("(src=|')", "", m.group()!)
                item.imgLink += result
            }
            if let m = re.search("<p>.*?</p>", rawDescription) {
                var result = re.sub("</*p>", "", m.group()!)
                item.summary = result
            }
        }
    }
}