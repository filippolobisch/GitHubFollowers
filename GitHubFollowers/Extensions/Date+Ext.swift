//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 28/10/2021.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        formatted(.dateTime.day().month(.wide).year())
    }
}
