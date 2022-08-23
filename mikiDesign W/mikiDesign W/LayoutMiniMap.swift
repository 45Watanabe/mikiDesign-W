//
//  LayoutMiniMap.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/18.
//

import SwiftUI

struct LayoutMiniMap: View {
    @ObservedObject var dispManager: DispManager = .dispManager
    @Binding var layout: [ShapeConfiguration]
    @StateObject var model: LayoutModel
    @State var reduction: CGFloat
    let iconList = ["", "wifi", "battery.100"]
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 10)
                .foregroundColor(Color.black.opacity(0.6))
                .frame(width: phone.w/reduction + 10,
                       height: phone.h/reduction + 10)
            
            VStack {
                HStack(spacing: 3) {
                    Text("23:59")
                        .font(.custom("Helvetica", size: 8))
                        .foregroundColor(Color.black)
                    Spacer()
                    ForEach(iconList, id: \.self){ name in
                        Image(systemName: "\(name)")
                            .resizable()
                            .frame(width: 7, height: 5)
                            .foregroundColor(Color.black)
                    }
                }
                Spacer()
            }
            .frame(width: phone.w/reduction,
                   height: phone.h/reduction)
            .padding(2)
            .border(Color.black.opacity(0.8), width: 1)
                
            
            ZStack {
                ForEach($layout){ status in
                    MiniShapeView(status: status, reduction: reduction)
                        .onTapGesture {
                            model.select = model.searchArray(id: status.id) ?? 0
                        }
                }
            }.frame(width: phone.w/reduction,
                    height: dispManager.safeAreaHeight/reduction)
            .padding(1)
            .border(Color.black.opacity(0.2), width: 1)
        }
    }
}
