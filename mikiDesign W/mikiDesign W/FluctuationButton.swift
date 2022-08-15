//
//  FluctuationButton.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/15.
//

import SwiftUI

// ?? [-] 0 [+]
struct FluctuationButton: View {
    let text: String
    let addIs1: Bool
    @Binding var value: CGFloat
    var body: some View {
        HStack {
            Text("\(text)")
            Image(systemName: "minus.rectangle")
                .resizable()
                .frame(width: phone.w/20, height: phone.w/20)
                .onTapGesture { value-=fluctuationValue() }

            Text("\(String(format: addIs1 ? "%.0f" : "%.1f", value))")
                .frame(width: 30, alignment: .center)

            Image(systemName: "plus.rectangle")
                .resizable()
                .frame(width: phone.w/20, height: phone.w/20)
                .onTapGesture { value+=fluctuationValue() }
        }
    }
    func fluctuationValue() -> CGFloat{
        return addIs1 ? 1 : 0.1
    }
}

