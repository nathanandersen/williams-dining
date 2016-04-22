//
//  CustomColorToolbar.swift
//  williams-dining
//
//  Created by Nathan Andersen on 2/16/17.
//  Copyright © 2017 Andersen Labs. All rights reserved.
//

import Foundation
import UIKit

class CustomColorToolbar: UIToolbar {

    private func sharedInit() {
        self.tintColor = Style.secondaryColor

        self.barTintColor = Style.defaultColor
        self.setBackgroundImage(UIImage(),
                                        forToolbarPosition: .any,
                                        barMetrics: .default)
        self.setShadowImage(UIImage(), forToolbarPosition: .any)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }
}
