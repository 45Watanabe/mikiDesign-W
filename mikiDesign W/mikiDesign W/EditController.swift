//
//  EditController.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/10.
//

import SwiftUI

struct ControllerView: View {
    @StateObject var model: LayoutModel
    let btnName = ButtonName()
    let modeList = ["Home", "EditShape", "SummonTab", "MoveShape", "MiniMap", "ObjectList"]
    let controller = size.controller
    var body: some View {
        ZStack {
//            ベース、影
            RoundedRectangle(cornerRadius: 5)
                .frame(width: controller.w + 1, height: model.isHide ? controller.h*0.1+1 : controller.h+1)
                .foregroundColor(Color.gray)
                .shadow(color: Color.black, radius: 2, x: 0, y: 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color.white)
                        .frame(width: controller.w,
                               height: model.isHide ? controller.h*0.1 : controller.h)
                )
            RoundedRectangle(cornerRadius: 5)
                            .frame(width: phone.w*0.5 + 1,
                                   height: model.isHide ? 31 : phone.w*0.8 + 1)
                            .foregroundColor(Color.gray)
                            .shadow(color: Color.black, radius: 2, x: 0, y: 0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(Color.white)
                                    .frame(width: phone.w*0.5,
                                           height: model.isHide ? 30 : phone.w*0.8)
                            )
            VStack(spacing: 0) {
//                モード切り替えボタン
                HStack(spacing: 5) {
                    Group {
                        Button(action: {
                            model.isHide.toggle()
                        }){
                            Image(systemName: model.isHide ? "plus.square.fill" : "minus.square.fill")
                        }
                        ForEach(modeList, id: \.self){ mode in
                            Button(action: {
                                model.selectTabMode = mode
                                model.isHide = false
                            }){
                                Image(systemName: btnName.getSymbol(name: mode))
                            }
                        }
                    }
                    .foregroundColor(Color.black)
                }
                .frame(height: controller.h*0.1)
                
                if !model.isHide {
                    Rectangle().frame(width: size.controller.w*0.95,height: 1.0).opacity(0.3)
                    if model.selectTabMode == "Home" {
                        HomeTab(model: model)
                    } else if model.selectTabMode == "EditShape" {
                        EditShapeTab(model: model, status: $model.shapeArray[model.select])
                    } else if model.selectTabMode == "MoveShape" {
                        MoveShapeTab(model: model, status: $model.shapeArray[model.select])
                    } else if model.selectTabMode == "MiniMap" {
                        MiniMapTab(model: model)
                    } else if model.selectTabMode == "SummonTab" {
                        SummonEditTab(model: model)
                    } else if model.selectTabMode == "ObjectList" {
                        objectListTab(model: model)
                    }
                    Rectangle().frame(width: size.controller.w*0.95,height: 1.0).opacity(0.3)
                        .padding(.bottom, 5)
                }
            }
            .frame(width: controller.w, height: model.isHide ? controller.h*0.1 : controller.h)
        }
    }
}

struct HomeTab: View {
    @StateObject var model: LayoutModel
    let btnName = ButtonName()
    let buttons1 = ["追加","追加&編集","編集"]
    let buttons2 = ["削除","コピー","ロック"]
    let buttons3 = ["最上","上げる","下げる","最下"]
    let buttons4 = ["保存","ホーム"]
    
    var body: some View {
        VStack(spacing: size.tabViewSize.w*0.07) {
            HStack(spacing: size.tabViewSize.w*0.07) {
                ForEach(buttons1, id:\.self) { name in
                    Button(action: {
                        model.tapButtonInHomeTab(name: name)
                    }){
                        ZStack{
                            ButtonBase(size: CGSize(width: phone.w/10, height: phone.w/10), text: name)
                            Image(systemName: btnName.getSymbol(name: name))
                                .resizable()
                                .frame(width: phone.w/10, height: phone.w/10)
                                .padding(.bottom, phone.w/50)
                        }
                    }
                }
            }
            HStack(spacing: size.tabViewSize.w*0.07) {
                ForEach(buttons2, id:\.self) { name in
                    Button(action: {
                        model.tapButtonInHomeTab(name: name)
                    }){
                        ZStack{
                            ButtonBase(size: CGSize(width: phone.w/10, height: phone.w/10), text: name)
                            Image(systemName: btnName.getSymbol(name: name))
                                .resizable()
                                .frame(width: phone.w/10, height: phone.w/10)
                                .padding(.bottom, phone.w/50)
                        }
                    }
                }
            }
            HStack {
                ForEach(buttons3, id:\.self) { name in
                    Button(action: {
                        model.tapButtonInHomeTab(name: name)
                    }){
                        ZStack{
                            ButtonBase(size: CGSize(width: phone.w/13, height: phone.w/13), text: "")
                            Image(systemName: btnName.getSymbol(name: name))
                                .resizable()
                                .frame(width: phone.w/13, height: phone.w/13)
                        }
                    }
                }
            }
            HStack {
                Button(action: {model.tapButtonInHomeTab(name: buttons4[0])}){
                    ZStack {
                        ButtonBase(size: CGSize(width: phone.w/10, height: phone.w/10), text: buttons4[0])
                        Image(systemName: btnName.getSymbol(name: buttons4[0]))
                            .resizable()
                            .frame(width: phone.w/12, height: phone.w/10)
                            .padding(.bottom, phone.w/50)
                        
                    }
                }
                Button(action: {model.tapButtonInHomeTab(name: buttons4[1])}){
                    ZStack {
                        ButtonBase(size: CGSize(width: phone.w/10, height: phone.w/10), text: buttons4[1])
                        Image(systemName: btnName.getSymbol(name: buttons4[1]))
                            .resizable()
                            .frame(width: phone.w/10, height: phone.w/11)
                            .padding(.bottom, phone.w/50)
                    }
                }
            }
            .fullScreenCover(isPresented: $model.isEditMode) {
                EditView(model: model, status: $model.shapeArray[model.select])
            }
        }
        .frame(width: size.tabViewSize.w, height: size.tabViewSize.h-5)
// FIXME:        .alert(isPresented: $model.showAlert, content: $model.processAlert)
    }
}

struct EditShapeTab: View {
    @StateObject var model: LayoutModel
    @Binding var status: ShapeConfiguration
    let StyleList = ["Rectangle", "Circle", "Ellipse", "Text"]
    var body: some View {
        VStack {
//            スタイル変更
            HStack(spacing: 5) {
                ForEach(StyleList, id: \.self){ style in
                    Button(action: {
                        status.style = style
                    }) {
                        editStyleButtons(style: style)
                    }
                }
            }
//            カラー変更
            selectColoriew(status: $status.color, changeStatus: "", small: true)
                .frame(width: phone.w/2.2)
//            サイズ変更
            VStack(spacing: 0) {
                Text("W: \(String(format: "%.0f", status.size.width))    H: \(String(format: "%.0f", status.size.height))")
                Slider(value: $status.size.width, in: 1...phone.w*1.1)
                    .frame(width: phone.w/2.2)
                Slider(value: $status.size.height, in: 1...phone.h*1.1)
                    .frame(width: phone.w/2.2)
            }
            
            ZStack {
                Spacer()
                    .frame(height: 35)
                if status.style == "Rectangle" {
//                    四角の場合の角丸め
                    HStack {
                        Text("丸さ \(String(format: "%.0f", status.corner))")
                            .foregroundColor(Color.black)
                            .frame(width: phone.w/6, alignment: .leading)
                        Slider(value: $status.corner, in: 0...99)
                            .frame(width: size.tabViewSize.w*0.5)
                    }.frame(width: size.tabViewSize.w, height: size.tabViewSize.h*0.1)
                } else if status.style == "Text" {
//                    テキストの場合の入力
                    TextField("テキストを入力", text: $status.text.character)
                        .frame(width: size.tabViewSize.w, height: size.tabViewSize.h*0.1)
                        .border(Color.gray)
                }
            }
            HStack {
                Button(action: { model.tapButtonInHomeTab(name: "追加")}){
                    Image(systemName: "plus.square")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                Button(action: { model.tapButtonInHomeTab(name: "編集") }){
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: phone.w/3, height: 25)
                        .foregroundColor(Color.blue)
                        .overlay(Text("もっと細かく編集")
                            .font(.caption).foregroundColor(Color.white))
                        .fullScreenCover(isPresented: $model.isEditMode) {
                            EditView(model: model, status: $model.shapeArray[model.select])
                                .foregroundColor(Color.black)
                        }
                }
            }
        }
        .frame(width: size.tabViewSize.w, height: size.tabViewSize.h-5)
    }
}

struct MoveShapeTab: View {
    @StateObject var model: LayoutModel
    @Binding var status: ShapeConfiguration
    @State var distance = 10
    let moveButtonSize = size.tabViewSize.w*0.3
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("X: \(String(format: "%.1f", status.position.x))")
                Spacer()
                Text("増減幅")
            }
            HStack(spacing: 0) {
                Text("Y: \(String(format: "%.1f", status.position.y))")
                Spacer()
                Button(action: {distance-=1}){
                    Text("-")
                }
                Text("\(distance)")
                    .frame(width: 25)
                Button(action: {distance+=1}){
                    Text("+")
                }
            }
            Spacer()
            moveButton(model: model, distance: $distance, orientation: "up")
            HStack(spacing: 0) {
                moveButton(model: model, distance: $distance, orientation: "left")
                Spacer().frame(width: size.tabViewSize.w*0.3)
                moveButton(model: model, distance: $distance, orientation: "right")
            }
            moveButton(model: model, distance: $distance, orientation: "down")
            Spacer()
            HStack{
                Image(systemName: "iphone").foregroundColor(Color.black)
                Text("横"+String(format: "%.0f", phone.w))
                Text("x")
                Text("縦"+String(format: "%.0f", phone.h))
            }
        }
        .frame(width: size.tabViewSize.w, height: size.tabViewSize.h-5)
    }
}

struct MiniMapTab: View {
    @StateObject var model: LayoutModel
    @State var reduction = CGFloat(3.5)
    var body: some View {
        VStack {
            LayoutMiniMap(layout: $model.shapeArray, model: model, reduction: reduction)
        }
        .frame(width: size.tabViewSize.w, height: size.tabViewSize.h-5)
    }
}

struct SummonEditTab: View {
    @StateObject var model: LayoutModel
    let btnName = ButtonName()
    let buttons1 = ["サイズ","フレーム","シャドウ"]
    let buttons2 = ["回転","カラー","閉じる"]
    var body: some View {
        ZStack {
            VStack(spacing: size.tabViewSize.w*0.1) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: phone.w/2.1, height: 30)
                    .foregroundColor(Color(red: 0, green: 0, blue: 0.5, opacity: 0.8))
                    .overlay(
                        Text("ミニウィンドウの呼び出し")
                            .font(.custom("Hiragino Sans", size: 13).weight(.bold))
                            .foregroundColor(Color.white)
                    )
                
                HStack(spacing: size.tabViewSize.w*0.07) {
                    ForEach(buttons1, id:\.self) { name in
                        Button(action: {
                            model.summonTab = name
                        }){
                            ZStack{
                                ButtonBase(size: CGSize(width: phone.w/10, height: phone.w/10), text: name)
                                Image(systemName: btnName.getSymbol(name: name))
                                    .resizable()
                                    .frame(width: phone.w/10, height: phone.w/10)
                                    .padding(.bottom, phone.w/50)
                            }
                        }
                    }
                }
                HStack(spacing: size.tabViewSize.w*0.07) {
                    ForEach(buttons2, id:\.self) { name in
                        Button(action: {
                            model.summonTab = name
                        }){
                            ZStack{
                                ButtonBase(size: CGSize(width: phone.w/10, height: phone.w/10), text: name)
                                Image(systemName: btnName.getSymbol(name: name))
                                    .resizable()
                                    .frame(width: phone.w/10, height: phone.w/10)
                                    .padding(.bottom, phone.w/50)
                            }
                        }
                    }
                }
            }
        }
        .frame(width: size.tabViewSize.w, height: size.tabViewSize.h-5)
    }
}

struct editStyleButtons: View {
    @State var style: String
    var body: some View {
        Group{
            if style == "Rectangle" {
                RoundedRectangle(cornerRadius: 0)
                    .frame(width: phone.w/13, height: phone.w/13)
            } else if style == "Circle" {
                Capsule()
                    .frame(width: phone.w/12, height: phone.w/12)
            } else if style == "Ellipse" {
                Ellipse()
                    .frame(width: phone.w/12, height: phone.w/14)
            } else if style == "Text" {
                Image(systemName: "t.square")
                    .resizable()
                    .frame(width: phone.w/14, height: phone.w/14)
            }
        }.foregroundColor(Color.black)
    }
}

struct objectListTab: View {
    @StateObject var model: LayoutModel
//    @State var shape_rev = model.shapeArray.reverse()
    let btnName = ButtonName()
    let buttons3 = ["最上","上げる","下げる","最下"]
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack(spacing: 3) {
                    Spacer().frame(height: 5)
                    ForEach($model.shapeArray){ status in
                        ObjectCell(status: status)
                            .border(model.getIndex(id: status.id) == model.select ?
                                    Color.pink : Color.gray)
                            .onTapGesture {
                                if let index = model.getIndex(id: status.id) {
                                    model.select = index
                                }
                            }
                    }
                }
            }
            .frame(width: size.tabViewSize.w)
            .border(Color.gray.opacity(0.3))
            HStack {
                ForEach(buttons3, id:\.self) { name in
                    Button(action: {
                        model.tapButtonInHomeTab(name: name)
                    }){
                        Image(systemName: btnName.getSymbol(name: name))
                            .resizable()
                            .frame(width: phone.w/13, height: phone.w/13)
                    }
                }
            }
            Spacer().frame(height: 5)
        }
        .frame(width: size.tabViewSize.w, height: size.tabViewSize.h-5)
    }
}
