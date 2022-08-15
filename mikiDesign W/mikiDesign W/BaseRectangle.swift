//
//  BaseRectangle.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/11.
//

import SwiftUI

struct BaseRectangle: View {
    let size: CGSize
    let text: String
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: size.width, height: size.height)
            .foregroundColor(Color.white)
            .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
            .overlay(
                Text("\(text)").font(.custom("Times New Roman", size: 10))
                    .frame(width: size.width, height: size.height, alignment: .topLeading)
            )
    }
}
