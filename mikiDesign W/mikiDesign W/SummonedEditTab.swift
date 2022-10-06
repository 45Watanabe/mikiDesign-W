//
//  SummonedEditTab.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/18.
//

import SwiftUI

struct SummonedEditTab: View {
    @StateObject var model: LayoutModel
    @Binding var status: ShapeConfiguration
    @State var isColorEdit = false
    @State var tabOpacity = 1.0
    
    var body: some View {
        VStack(spacing: 5) {
            if model.summonTab != "閉じる" {
                HStack {
                    Button(action: {model.summonTab = "閉じる"}){
                        Image(systemName: "x.square.fill")
                            .foregroundColor(Color.black)
                    }
                    Button(action: {tabOpacity = 0.2}){
                        Image(systemName: "circle.fill")
                            .foregroundColor(Color.black.opacity(0.2))
                    }
                    Button(action: {tabOpacity = 1.0}){
                        Image(systemName: "circle.fill")
                            .foregroundColor(Color.black.opacity(1.0))
                    }
                }.frame(width: phone.w*0.8, alignment: .leading)
            }
            if model.summonTab == "サイズ" {
                editSizeView(status: $status)
            } else if model.summonTab == "カラー" {
                selectColoriew(status: $status.color, changeStatus: "", small: false)
            } else if model.summonTab == "フレーム" {
                editFrameView(status: $status, isColorEdit: $isColorEdit)
                if isColorEdit {
                    selectColoriew(status: $status.frame.color, changeStatus: "フレーム", small: false)
                }
            } else if model.summonTab == "シャドウ" {
                editShadowView(status: $status, isColorEdit: $isColorEdit)
                if isColorEdit {
                    selectColoriew(status: $status.frame.color, changeStatus: "シャドウ", small: false)
                }
            } else if model.summonTab == "回転" {
                editRotationView(status: $status)
            } else if model.summonTab == "閉じる" {
                
            }
        }.opacity(tabOpacity)
    }
}
