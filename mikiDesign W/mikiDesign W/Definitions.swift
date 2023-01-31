//
//  Definitions.swift
//  mikiDesign
//
//  Created by 渡辺幹 on 2022/12/28.
//

import SwiftUI

struct phone {
    static let w = UIScreen.main.bounds.width
    static let h = UIScreen.main.bounds.height
}

struct size {
    static let controller: (w: CGFloat, h: CGFloat) = (w: phone.w*0.5, h: phone.w*0.8)
    static let moveShadow: (w: CGFloat, h: CGFloat, line: CGFloat) = (w: phone.w*0.5 + 10, h: phone.w*0.8 + 10, line: 10)
    static let tabViewSize: (w: CGFloat, h: CGFloat) = (w: controller.w*0.95, h: controller.h*0.9)
}

struct makedColor {
    static let darkBlue = Color(red: 0.2, green: 0.0, blue: 1.0)
}

struct TestColorView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .frame(width: phone.w*0.8,
                   height: phone.w*1.28)
            .foregroundColor(makedColor.darkBlue)
    }
}

struct TestColorView_Previews: PreviewProvider {
    static var previews: some View {
        TestColorView()
    }
}

struct ButtonName {
    // ["ボタンの名前": "SFSymbol"]
    let collection = ["追加": "plus.square",
                      "追加&編集": "wand.and.rays",
                      "編集": "wand.and.stars",
                      "削除": "trash.square",
                      "コピー": "rectangle.on.rectangle.square",
                      "ロック": "lock.square",
                      "最上": "square.3.stack.3d.top.filled",
                      "上げる": "square.2.stack.3d.top.filled",
                      "下げる": "square.2.stack.3d.bottom.filled",
                      "最下": "square.3.stack.3d.bottom.filled",
                      "保存": "square.and.arrow.down",
                      "ホーム": "house",
                      "サイズ": "crop",
                      "フレーム": "square.dashed.inset.filled",
                      "シャドウ": "shadow",
                      "回転": "rotate.left",
                      "カラー": "paintbrush",
                      "閉じる": "x.square.fill",
                      "Home": "house",
                      "EditShape": "wand.and.stars.inverse",
                      "SummonTab": "macwindow.badge.plus",
                      "MoveShape": "circle.grid.cross",
                      "MiniMap": "iphone.circle",
                      "ObjectList": "list.bullet.circle"
    ]
    
    func getSymbol(name: String) -> String{
        return collection[name] ?? "exclamationmark.circle.fill"
    }
}

