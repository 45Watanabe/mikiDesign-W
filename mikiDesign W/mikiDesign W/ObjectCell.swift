//
//  ObjectCell.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2023/01/05.
//

import SwiftUI

struct ObjectCell: View {
    @Binding var status: ShapeConfiguration
    @State var objectName = ""
    var body: some View {
        HStack {
            Spacer().frame(width: size.tabViewSize.w*0.01)
            ObjectIcon(status: $status, objectName: $objectName)
                .frame(width: size.tabViewSize.w*0.5, height: size.tabViewSize.h*0.2)
                .clipped()
                .border(Color.gray.opacity(0.2))
                
            VStack {
                Text(objectName)
            }
            .frame(width: size.tabViewSize.w*0.4, height: size.tabViewSize.h*0.2)
        }.frame(width: size.tabViewSize.w*0.95,
                height: size.tabViewSize.h*0.22)
    }
}

struct ObjectIcon: View {
    @Binding var status: ShapeConfiguration {
        didSet {
            sizeAdjustment()
        }
    }
    let windowSize = CGSize(width: size.tabViewSize.w*0.5, height: size.tabViewSize.h*0.2)
    @State var iconSize = CGSize(width: size.tabViewSize.w*0.5, height: size.tabViewSize.h*0.2)
    @Binding var objectName: String
    var body: some View {
        ZStack {
            if Color(red: status.color.r, green: status.color.g, blue: status.color.b) == Color.white {
                Color.gray.opacity(0.3)
            }
            Group {
                if status.style == "Rectangle" {
                    Rectangle()
                        .frame(width: iconSize.width, height: iconSize.height)
                } else if status.style == "Circle" {
                    Capsule()
                        .frame(width: iconSize.width, height: iconSize.height)
                } else if status.style == "Ellipse" {
                    Ellipse()
                        .frame(width: iconSize.width, height: iconSize.height)
                } else if status.style == "Text" {
                    Text(status.text.character == "" ? "テキスト" : status.text.character)
                        .font(.custom(status.text.font, size: status.text.size/3))
                } else if status.style == "SFSymbols" {
                    Image(systemName: status.symbolName)
                        .frame(width: iconSize.width, height: iconSize.height)
                }
            }
            .foregroundColor(Color(red: status.color.r, green: status.color.g, blue: status.color.b))
        }
        .onAppear(){
            sizeAdjustment()
        }
    }
    func sizeAdjustment() {
        if status.size.width < windowSize.width*0.9 && status.size.height < windowSize.height*0.9 {
            iconSize = status.size
        } else {
            if status.size.width - status.size.height < -15 {
                iconSize = CGSize(width: windowSize.height*0.4, height: windowSize.height*0.7)
                objectName = "長方形"
            } else if status.size.width - status.size.height > 15 {
                iconSize = CGSize(width: windowSize.width*0.7, height: windowSize.width*0.4)
                objectName = "長方形"
            } else {
                iconSize = CGSize(width: windowSize.width*0.7, height: windowSize.width*0.7)
                objectName = "正方形"
            }
        }
        if status.style != "Rectangle" {
            setObjectName(isRectangle: false)
        }
    }
    func setObjectName(isRectangle: Bool) {
        switch status.style {
//        case "Rectangle": objectName = "四角"
        case "Circle": objectName = "丸"
        case "Ellipse": objectName = "楕円"
        case "Text": objectName = "テキスト"
        case "SFSymbols": objectName = "アイコン"
        default : print("it is not style")
        }
    }
}
