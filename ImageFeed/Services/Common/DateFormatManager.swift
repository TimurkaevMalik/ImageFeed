//
//  RecievedDateFormatter.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 17.03.2024.
//

import Foundation

class DateFormatManager {
    
    static let shared = DateFormatManager()
    
    private let isoDateFormatter = ISO8601DateFormatter()
    private lazy var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private init(){}
    
    
    func fomateStringDate(string: String?) -> String? {
        guard let dateString = string else {return nil}
        
        let date = isoDateFormatter.date(from: dateString)
        
        guard let date = date else {return nil}
        
        return dateFormatter.string(from: date)
    }
}
