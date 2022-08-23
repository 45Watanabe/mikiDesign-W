//
//  Model.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/10.
//


import SwiftUI

class LayoutModel: ObservableObject {
    @ObservedObject var dispManager: DispManager = .dispManager
    
    @Published var shapeArray: [ShapeConfiguration] = []
    @Published var beforeEditPosition = CGPoint(x: 0, y: 0)
    @Published var select = 0
    @Published var isHide = false
    @Published var selectTabMode = "Home"
    @Published var isEditMode = false
    @Published var summonTab = "empty"
    
    init(){
        if shapeArray.isEmpty {
            addShape()
        }
    }
    
    func assignmentLayout() {
        shapeArray = dispManager.savedLayouts[dispManager.selectIndex]
        if shapeArray.isEmpty {
            addShape()
        }
    }
    
    // レイアウトのセーブ
    func saveLayout() {
        dispManager.savedLayouts[dispManager.selectIndex] = shapeArray
        let encoder = JSONEncoder()
        if let jsonValue = try? encoder.encode(dispManager.savedLayouts) {
            UserDefaults.standard.set(jsonValue, forKey: "user")
        } else {
            fatalError("Failed to encode to JSON.")
        }
    }
    
    func selectedShape() -> ShapeConfiguration {
        return shapeArray[select]
    }
    
    func tapButtonInHomeTab(name: String) {
        switch name {
        case "plus.square": addShape()
        case "wand.and.rays": addShape(); editMode(isMove: true)
        case "wand.and.stars": editMode(isMove: true)
        case "trash.square": removeShape()
        case "rectangle.on.rectangle.square": copyShape()
        case "lock.square": lockMoveShape()
        case "square.3.stack.3d.top.filled": changeOrder(order: "top")
        case "square.2.stack.3d.top.filled": changeOrder(order: "up")
        case "square.2.stack.3d.bottom.filled": changeOrder(order: "down")
        case "square.3.stack.3d.bottom.filled": changeOrder(order: "bottom")
        case "questionmark.circle": break
        default: break
        }
    }

    func addShape() {
        if shapeArray.count == 0 {
            shapeArray.append(sampleShape().sampleRectangle)
            select = shapeArray.count-1
        }
    }
    
    func removeShape() {
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
        case "y-": shapeArray[select].position.y -= CGFloat(distance)
        case "y+": shapeArray[select].position.y += CGFloat(distance)
        case "x-": shapeArray[select].position.x -= CGFloat(distance)
        case "x+": shapeArray[select].position.x += CGFloat(distance)
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


class sampleShape {
    let sampleRectangle: ShapeConfiguration = ShapeConfiguration(style: "Rectangle", color: SColor(r: 1, g: 0, b: 0, o: 1) , size: CGSize(width: 100, height: 100), position: CGPoint(x: phone.w/2, y: phone.h/2), opacity: 1.0, rotation: 0.0, shadow: ShadowConfiguration(color: SColor(r: 0, g: 0, b: 0, o: 0), radius: 0, x: 0, y: 0), frame: FrameConfiguration(width: 1, color: SColor(r: 0, g: 0, b: 0, o: 0), opacity: 0.5), lock: false, corner: 0, symbolName: "applelogo", text: TextConfiguration(character: "", font: "Copperplate", size: 20))
    
}
