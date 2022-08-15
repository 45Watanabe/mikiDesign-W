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
}


