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
    private let layout = [GridItem(.adaptive(minimum: UIScreen.main.bounds.width/2.5), alignment: .top)]
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.blue)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer().frame(height: phone.h*0.1)
                
                ScrollView {
                    Spacer().frame(height: 50)
                    LazyVGrid(columns: layout, spacing: 3) {
                        ForEach(0..<dispManager.savedLayouts.count){ num in
                            Button(action: {
                                dispManager.selectIndex = num
                            }){
                                LayoutMiniMap(layout: $dispManager.savedLayouts[num], model: model, reduction: 3)
                                    .clipped()
                                    .padding(5)
                                    .border(dispManager.selectIndex == num ? Color.red : Color.clear,
                                            width: 5)
                                    .overlay(
                                        Image("clear")
                                            .frame(width: phone.w/2.5, height: phone.h/3)
                                            .foregroundColor(Color.clear)
                                    )
                                    
                            }
                        }
                        Button(action: {
                            dispManager.selectIndex = dispManager.savedLayouts.count
                            dispManager.savedLayouts.append([])
                            dispManager.display = "Layout"
                        }){
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 3)
                                .frame(width: phone.w/3, height: phone.h/3)
                                .padding(5)
                                .overlay(
                                    Text("＋")
                                        .font(.custom("default", size: 50))
                                )
                        }
                    }
                    Spacer().frame(height: 50)
                }
                .frame(width: phone.w, height: phone.h*0.7)
                .background(Color.white)
                
                // 画面下部の操作ボタン。編集 新規 削除
                HStack(spacing: phone.w/15) {
                    Button(action: {
                        dispManager.display = "Layout"
                    }){
                        Image(systemName: "wand.and.stars")
                            .resizable()
                            .frame(width: phone.w/10, height: phone.w/10)
                            .foregroundColor(Color.white)
                    }
                    Button(action: {
                        dispManager.selectIndex = dispManager.savedLayouts.count
                        dispManager.savedLayouts.append([])
                        dispManager.display = "Layout"
                    }){
                        Image(systemName: "plus.square")
                            .resizable()
                            .frame(width: phone.w/10, height: phone.w/10)
                            .foregroundColor(Color.white)
                    }
                    Button(action: {}){
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: phone.w/10, height: phone.w/10)
                            .foregroundColor(Color.white)
                    }
                }.frame(height: phone.h*0.1)
                Spacer().frame(height: phone.h*0.1)
                
            }.frame(height: phone.h)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
