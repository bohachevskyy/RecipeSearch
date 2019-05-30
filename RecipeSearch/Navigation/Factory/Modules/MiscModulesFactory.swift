//
//  MiscModulesFactory.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation
import SafariServices

protocol MiscModulesFactory {
    func makeSafariView(url: URL) -> SFSafariViewController
}
