//
//  File.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-03.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import Foundation
import WatSwift

WatSwift.apiKey = "532bfebea989a4a5bc40da4fc7d6b1d4";

WatSwift.FoodServices.menu { response in
    let metadata = response.metadata;
    //let data: JSON = response.data;
    print(metadata);
}
