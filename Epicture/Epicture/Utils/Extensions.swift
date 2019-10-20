//
//  Extensions.swift
//  Epicture
//
//  Created by Cecile on 20/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import Foundation

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
}
