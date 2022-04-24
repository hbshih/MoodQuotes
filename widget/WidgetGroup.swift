//
//  WidgetGroup.swift
//  WidgetGroup
//
//  Created by Tihomir RAdeff on 3.10.20.
//

import WidgetKit
import SwiftUI
import SwiftyStoreKit

@main
struct WidgetGroup: WidgetBundle {

    var body: some Widget {
            SmallWidget_Plant()
            SmallWidget_Date()
      //  MediumWidget_Quote_3()
        LargeWidget_Full()
            WidgetGroup2().body
           // LargeWidget_Full()
    }
}

struct WidgetGroup2: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        MediumWidget_Quote()
        MediumWidget_Quote_2()
    }
}

