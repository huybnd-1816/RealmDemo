//
//  Data+.swift
//  RealmDemo
//
//  Created by nguyen.duc.huyb on 6/7/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

extension Data {
    //Convert Data to Hex String
    var hexDescription: String {
        return reduce("") { $0 + String(format: "%02x", $1) }
    }
}
