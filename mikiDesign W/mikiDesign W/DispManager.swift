//
//  DispManager.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/15.
//

import SwiftUI

class DispManager: ObservableObject {
    static let dispManager = DispManager()
    @ObservedObject var fire = FireBaseManager()
    @Published var display = "Title"
    @Published var safeAreaHeight = CGFloat(0)
    
    @Published var savedLayouts: [Layouts] = []
    @Published var fireLayouts: [Layouts] = []
    @Published var selectLayoutsId = ""
    
    init() {
        loadLayout()
    }
    
    func selectLayout() {
        display = "Layout"
    }
    
    func getLayoutIndex(id: String) -> Int{
        if let index = savedLayouts.firstIndex(where: {$0.id == id}){
            return index
        }
        return 0
    }
    
    // レイアウトのロード
    func loadLayout() {
        if let savedValue = UserDefaults.standard.data(forKey: "savedLayouts") {
            let decoder = JSONDecoder()
            guard let array: [Layouts] = try?
                    decoder.decode([Layouts].self, from: savedValue) else {
                fatalError("Failed to decode from JSON.")
            }
            savedLayouts = array
        }
    }
    
    func getFirebasesLayout() {
        fire.getLayoutData()
    }
}


