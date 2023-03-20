//
//  Model.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/10.
//


import SwiftUI

class LayoutModel: ObservableObject {
    @ObservedObject var dispManager: DispManager = .dispManager
    
    let alerts = AlertCollection()
    
    @Published var shapeArray: [ShapeConfiguration] = []
    @Published var beforeEditPosition = CGPoint(x: 0, y: 0)
    @Published var select = 0
    @Published var isHide = false
    @Published var selectTabMode = "Home"
    @Published var isEditMode = false
    @Published var summonTab = "閉じる"
    @Published var shouwingUploads = false
    @Published var areltFlag:(save: Bool, home: Bool, delete: Bool) = (save: false, home: false, delete: false)
    
    
    init(){
        if shapeArray.isEmpty {
            addShape()
        }
    }
    
    func assignmentLayout() {
        shapeArray = dispManager.savedLayouts[dispManager.getLayoutIndex(id: dispManager.selectLayoutsId)].layout
        if shapeArray.isEmpty {
            addShape()
        }
    }
    
    // レイアウトのセーブ
    func saveLayout() {
        dispManager.savedLayouts[dispManager.getLayoutIndex(id: dispManager.selectLayoutsId)] = Layouts(id: dispManager.selectLayoutsId, name: "", category: "ネタ", canCopy: true, layout: shapeArray, good:0,bad:0)
        let encoder = JSONEncoder()
        guard let jsonValue = try? encoder.encode(dispManager.savedLayouts) else {
            fatalError("Failed to encode to JSON.")
        }
        UserDefaults.standard.set(jsonValue, forKey: "savedLayouts")
        for layout in dispManager.savedLayouts {
            print(layout.id)
        }
        print("---------------------------------------")
    }
    
    func saveOnlineLayout(data: Layouts) {
        if let _ = dispManager.savedLayouts.firstIndex(where: {$0.id == data.id}) {
            removeLayout(layoutId: data.id)
        }
        dispManager.savedLayouts.append(data)
        saveLayout()
    }
    
    func removeLayout(layoutId: String) {
        dispManager.savedLayouts.removeAll(where : { $0.id == layoutId })
    }
    
    func GoUploadLayout() {
        shouwingUploads.toggle()
    }
    
    func selectedShape() -> ShapeConfiguration {
        return shapeArray[select]
    }
    
    func getIndex(id: String) -> Int? {
        var result: Int?
        for i in 0 ..< shapeArray.count {
            if shapeArray[i].id == id {
                result = i
            }
        }
        return result
    }
    
    func tapButtonInHomeTab(name: String) {
        switch name {
        case "追加": addShape()
        case "追加&編集": addShape(); editMode(isMove: true)
        case "編集": editMode(isMove: true)
        case "削除": areltFlag.delete.toggle()
        case "コピー": copyShape()
        case "ロック": lockMoveShape()
        case "最上": changeOrder(order: "top")
        case "上げる": changeOrder(order: "up")
        case "下げる": changeOrder(order: "down")
        case "最下": changeOrder(order: "bottom")
        case "questionmark.circle": break
        case "ホーム": areltFlag.home.toggle()
        case "保存": areltFlag.save.toggle()
        case "公開": GoUploadLayout()
        default: break
        }
        
    }
    
    func addShape() {
        shapeArray.append(sampleShape().sampleRectangle)
        select = shapeArray.count-1
    }
    
    func removeShape(){
        if shapeArray.count > 1 {
            self.shapeArray.remove(at: select)
            if select > 0 {
                select-=1
            }
        }
    }
    
    func copyShape() {
        var shape: ShapeConfiguration = selectedShape()
        shape.id = UUID().uuidString
        shape.position.x -= 10
        shape.position.y -= 10
        select += 1
        shapeArray.insert(shape, at: select)
    }
    
    func lockMoveShape() {
        shapeArray[select].lock.toggle()
    }
    
    func editMode(isMove: Bool) {
        if isMove {
            isEditMode = true
            beforeEditPosition = selectedShape().position
            shapeArray[select].position = CGPoint(x: phone.w/2, y: phone.h/3)
        } else {
            shapeArray[select].position = beforeEditPosition
        }
    }
    
    func changeOrder(order: String) {
        if shapeArray.count > 1 {
            let shape: ShapeConfiguration = selectedShape()
            
            switch order {
            case "top":
                shapeArray.insert(shape, at: shapeArray.count)
                self.shapeArray.remove(at: select)
                select = shapeArray.count-1
            case "bottom":
                shapeArray.insert(shape, at: 0)
                self.shapeArray.remove(at: select+1)
                select = 0
            case "up":
                if select < shapeArray.count-1 {
                    shapeArray.insert(shape, at: select+2)
                    self.shapeArray.remove(at: select)
                    select+=1
                }
            case "down":
                if select > 0 {
                    shapeArray.insert(shape, at: select-1)
                    self.shapeArray.remove(at: select+1)
                    select-=1
                }
            default: break
            }
            
        }
    }
    
    func moveShape(direction: String, distance: Int) {
        switch direction {
        case "up": shapeArray[select].position.y -= CGFloat(distance)
        case "down": shapeArray[select].position.y += CGFloat(distance)
        case "left": shapeArray[select].position.x -= CGFloat(distance)
        case "right": shapeArray[select].position.x += CGFloat(distance)
        default: break
        }
    }
    
    func searchArray(id: String) -> Int? {
        var count = 0
        for shapeArray in shapeArray {
            if shapeArray.id == id {
                return count
            } else {
                count+=1
            }
        }
        return nil
    }
    
}

class AlertCollection {
    func returnAlert(processName: String, _ handler: @escaping ()->()) -> Alert {
        var result: Alert
        switch processName {
        case "オブジェクトの削除": result = Alert(title: Text("オブジェクトの削除"),
                                         message: Text("\n図形を削除します。"),
                                         primaryButton: .cancel(Text("いいえ")),
                                         secondaryButton: .destructive(Text("はい"),action: {handler()}))
        case "レイアウトの削除": result = Alert(title: Text("レイアウトの削除"),
                                        message: Text("\nレイアウトを削除しますか？"),
                                        primaryButton: .cancel(Text("いいえ")),
                                        secondaryButton: .destructive(Text("はい"),action: {handler()}))
        case "ホームへ戻る": result = Alert(title: Text("ホームへ戻ります。"),
                                      message: Text("\nレイアウトをセーブしますか？"),
                                      primaryButton: .cancel(Text("いいえ")),
                                      secondaryButton: .destructive(Text("はい"),action: {handler()}))
        default: result = Alert(title: Text("処理に失敗しました。"),
                                message: Text("\n開発者にレポートを送信しますか？"),
                                primaryButton: .cancel(Text("無視")),
                                secondaryButton: .destructive(Text("レポート"),action: {print("削除")}))
        }
        
        return result
    }
    
}


class sampleShape {
    let sampleRectangle: ShapeConfiguration = ShapeConfiguration(style: "Rectangle", color: SColor(r: 1, g: 0, b: 0, o: 1) , size: CGSize(width: 100, height: 100), position: CGPoint(x: phone.w/2, y: phone.h/2), opacity: 1.0, rotation: 0.0, shadow: ShadowConfiguration(color: SColor(r: 0, g: 0, b: 0, o: 0), radius: 0, x: 0, y: 0), frame: FrameConfiguration(width: 1, color: SColor(r: 0, g: 0, b: 0, o: 0), opacity: 0.5), lock: false, corner: 0, symbolName: "applelogo", text: TextConfiguration(character: "", font: "Hiragino Sans", size: 20))
    
}
