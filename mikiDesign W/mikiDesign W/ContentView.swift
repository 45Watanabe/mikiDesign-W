//
//  ContentView.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/03.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var dispManager: DispManager = .dispManager
    var body: some View {
        if dispManager.display == "Title" {
            TitleView()
        } else if dispManager.display == "Home" {
            HomeView()
        } else if dispManager.display == "Layout" {
            LayoutView()
        } else if dispManager.display == "" {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct phone {
    static let w = UIScreen.main.bounds.width
    static let h = UIScreen.main.bounds.height
}