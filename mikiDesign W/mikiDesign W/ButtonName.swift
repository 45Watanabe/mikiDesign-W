//
//  ButtonName.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/10/05.
//

import Foundation

struct ButtonName {
    // ["ボタンの名前": "SFSymbol"]
    let aaa: [String: String] = ["追加": "plus.square", "追加&編集": "wand.and.rays", "編集": "wand.and.stars",
                                 "削除": "trash.square", "コピー": "rectangle.on.rectangle.square", "ロック": "lock.square",
                                 "最上": "square.3.stack.3d.top.filled", "上げる": "square.2.stack.3d.top.filled",
                                 "下げる": "square.2.stack.3d.bottom.filled", "最下": "square.3.stack.3d.bottom.filled",
                                 "保存": "square.and.arrow.down", "ホーム": "house",
                                 "サイズ": "crop", "フレーム": "square.dashed.inset.filled", "シャドウ": "shadow",
                                 "回転": "rotate.left", "カラー": "paintbrush", "閉じる": "x.square.fill"]
    
    func getSymbol(name: String) -> String{
        return aaa[name] ?? "exclamationmark.circle.fill"
    }
}
