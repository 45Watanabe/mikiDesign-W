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
            if model.summonTab != "empty" {
                HStack {
                    Button(action: {model.summonTab = "empty"}){
                        Image(systemName: "minus.square.fill")
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
            if model.summonTab == "size" {
                editSizeView(status: $status)
            } else if model.summonTab == "color" {
                selectColoriew(status: $status.color, changeStatus: "", small: false)
            } else if model.summonTab == "frame" {
                editFrameView(status: $status, isColorEdit: $isColorEdit)
                if isColorEdit {
                    selectColoriew(status: $status.frame.color, changeStatus: "フレーム", small: false)
                }
            } else if model.summonTab == "shadow" {
                editShadowView(status: $status, isColorEdit: $isColorEdit)
                if isColorEdit {
                    selectColoriew(status: $status.frame.color, changeStatus: "シャドウ", small: false)
                }
            } else if model.summonTab == "rotation" {
                editRotationView(status: $status)
            } else if model.summonTab == "empty" {
                
            }
        }.opacity(tabOpacity)
    }
}
