//
//  UIApplication.swift
//  PodCast_Swift
//
//  Created by frizhub on 17/09/2023.
//

import Foundation
import UIKit

extension UIApplication {
    var currentWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
