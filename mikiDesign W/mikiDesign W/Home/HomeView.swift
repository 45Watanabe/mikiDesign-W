//
//  HomeView.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/10.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var dispManager: DispManager = .dispManager
    @StateObject private var model = LayoutModel()
    private let layout = [GridItem(.adaptive(minimum: UIScreen.main.bounds.width/2.5),
                                   alignment: .top)]
    var body: some View {
        ZStack {
            Rectangle()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                Spacer().frame(height: 10)
                LazyVGrid(columns: layout, spacing: 3) {
                    ForEach(0..<dispManager.savedLayouts.count){ num in
                        Button(action: {
                            model.select = num
                        }){
                            LayoutMiniMap(model: model, reduction: 2.5)
                        }
                    }
                    Button(action: {}){
                        
                    }
                }
            }
            
            VStack(spacing: 0) {
                Rectangle()
                    .frame(width: phone.w, height: phone.h*0.1)
                    .foregroundColor(Color.blue)
                Rectangle()
                    .frame(width: phone.w, height: phone.h*0.8)
                    .foregroundColor(Color.white)
                Rectangle()
                    .frame(width: phone.w, height: phone.h*0.1)
                    .foregroundColor(Color.blue)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
