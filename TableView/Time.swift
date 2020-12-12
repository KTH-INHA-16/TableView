//
//  Time.swift
//  TableView
//
//  Created by 김태훈 on 2020/12/09.
//

import UIKit

class Time {
    var year: String
    var month: String
    var day: String
    var hour: String
    var min: String
    var sec: String
    
    init() {
        let date = DateFormatter()
        date.dateFormat = "yyyy"
        self.year = date.string(from: Date())
        date.dateFormat = "MM"
        self.month = date.string(from: Date())
        date.dateFormat = "dd"
        self.day = date.string(from: Date())
        date.dateFormat = "HH"
        self.hour = date.string(from: Date())
        date.dateFormat = "mm"
        self.min = date.string(from: Date())
        date.dateFormat = "ss"
        self.sec = date.string(from:Date())
    }

}
