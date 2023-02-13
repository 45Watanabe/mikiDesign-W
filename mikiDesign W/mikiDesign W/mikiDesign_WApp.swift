//
//  mikiDesign_WApp.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/03.
//

import SwiftUI
import Firebase


@main
struct mikiDesign_WApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
//            TestView()
        }
    }
}
