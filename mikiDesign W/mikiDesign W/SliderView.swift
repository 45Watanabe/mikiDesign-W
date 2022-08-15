//
//  SliderView.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/10.
//

import SwiftUI

// OO: 00 [-] -o------------ [+]
struct SliderView: View {
    let text: String
    let width: CGFloat
    let min: CGFloat
    let max: CGFloat
    @Binding var value: CGFloat
    
    var body: some View {
        HStack {
            Text("\(text): \(String(format: "%.0f", value))")
                .frame(width: 70, alignment: .leading)
            
            Image(systemName: "minus.rectangle")
                .resizable()
                .frame(width: phone.w/20, height: phone.w/20)
                .onTapGesture { value-=1 }
            
            Slider(value: $value, in: min...max)
                .frame(width: width)
            
            Image(systemName: "plus.rectangle")
                .resizable()
                .frame(width: phone.w/20, height: phone.w/20)
                .onTapGesture { value+=1 }
        }
    }
}

