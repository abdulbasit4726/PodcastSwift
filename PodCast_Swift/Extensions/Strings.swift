//
//  Extensions.swift
//  PodCast_Swift
//
//  Created by frizhub on 15/09/2023.
//

import UIKit

extension String {
    func toSecureHTTP() -> String {
        self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
