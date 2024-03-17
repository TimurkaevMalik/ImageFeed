//
//  RecievedDateFormatter.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 17.03.2024.
//

import Foundation

class RecievedDateFormatter {
    
    
    private lazy var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    func fomateStringDate(string: String?) -> String? {
        
        if let dateString = string  {
            
            let isoDateFormatter = ISO8601DateFormatter()
            let date = isoDateFormatter.date(from: dateString)
            
            guard let date = date else {return nil}
            
            let formatedString = dateFormatter.string(from: date)
            
            return formatedString
        } else {
            return nil
        }
    }
}
