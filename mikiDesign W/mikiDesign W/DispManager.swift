//
//  DispManager.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/15.
//

import SwiftUI

class DispManager: ObservableObject {
    static let dispManager = DispManager()
    @Published var display = "Title"
    @Published var safeAreaHeight = CGFloat(0)
    
    @Published var savedLayouts: [[ShapeConfiguration]] = [[]]
    @Published var selectIndex = 0
    
    init() {
        loadLayout()
    }
    
    func selectLayout() {
        display = "Layout"
    }
    
    // レイアウトのロード
    func loadLayout() {
        if let savedValue = UserDefaults.standard.data(forKey: "user") {
            let decoder = JSONDecoder()
            if let array: [[ShapeConfiguration]] = try?
                decoder.decode([[ShapeConfiguration]].self, from: savedValue) {
                savedLayouts = array
            } else {
                fatalError("Failed to decode from JSON.")
            }
        }
    }
}


