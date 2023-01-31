//
//  MoveButton.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2023/01/02.
//

import SwiftUI

// 移動ボタン
struct moveButton: View {
    @StateObject var model: LayoutModel
    @Binding var distance: Int
    let orientation: String
    let buttonSize = size.tabViewSize.w*0.3
    @State var timerHandler : Timer?
    @State var isPress = false
    @State var revolution = 0.0
    var body: some View {
        ZStack {
            if isPress {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 3, dash: [7]))
                    .foregroundColor(Color.cyan)
                    .rotationEffect(Angle(degrees: revolution))
//                    .animation(.default, value: isPress)
                    .animation(.default, value: revolution)
            }
            Button(action: {
                if isPress {
                    endLongPress()
                } else {
                    buttonOnTap()
                }
            }, label: {
                Image(systemName: "arrowtriangle.\(orientation).circle.fill")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
                    .foregroundColor(isPress ? Color.cyan : Color.black)
            })
            .simultaneousGesture(
                LongPressGesture().onEnded{ _ in
                    startLongPress()
                }
            )
        }.frame(width: buttonSize*0.9, height: buttonSize*0.9)
    }
    // 単押しの場合の処理
    func buttonOnTap() {
//        print("Tap")
        model.moveShape(direction: orientation, distance: distance)
    }
    // 長押しの場合の処理
    func startLongPress() {
//        print("long_start")
        isPress = true
        startEngine()
    }
    func endLongPress() {
//        print("long_finish")
        isPress.toggle()
        timerHandler?.invalidate()
    }
    
    func startEngine() {
        if let unwrapedTimerHandler = timerHandler{
            if unwrapedTimerHandler.isValid == true{
                return
            }
        }
        timerHandler = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ _ in
            if revolution == 360.0 { revolution = 0.0 }
            self.revolution += 40.0
            model.moveShape(direction: orientation, distance: distance)
        }
    }
}
