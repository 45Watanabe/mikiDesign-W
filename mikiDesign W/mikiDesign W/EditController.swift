//
//  EditController.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/10.
//

import SwiftUI

struct ControllerView: View {
    @StateObject var model: LayoutModel
    var body: some View {
        ZStack {
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
                HStack(spacing: 10) {
                    Group {
                        Button(action: {
                            model.isHide.toggle()
                        }){
                            Image(systemName: model.isHide ?
                                  "plus.square.fill" : "minus.square.fill")
                        }
                        Button(action: {
                            model.selectTabMode = "Home"
                            model.isHide = false
                        }){
                            Image(systemName: "house")//plus.square.on.square
                        }
                        Button(action: {
                            model.selectTabMode = "EditShape"
                            model.isHide = false
                        }){
                            Image(systemName: "wand.and.stars.inverse")
                        }
                        Button(action: {
                            model.selectTabMode = "SummonTab"
                            model.isHide = false
                        }){
                            Image(systemName: "macwindow.badge.plus")
                        }
                        Button(action: {
                            model.selectTabMode = "MoveShape"
                            model.isHide = false
                        }){
                            Image(systemName: "circle.grid.cross")
                        }
                        Button(action: {
                            model.selectTabMode = "MiniMap"
                            model.isHide = false
                        }){
                            Image(systemName: "iphone.circle")
                        }
                    }.foregroundColor(Color.black)
                }
                if !model.isHide {
                    Spacer()
                    ControlTabView(model: model,
                                   status: $model.shapeArray[model.select],
                                   tabMode: $model.selectTabMode)
                    .frame(height: phone.w*0.8-50)
                    Spacer()
                }
            }.frame(width: phone.w*0.5,
                    height: model.isHide ? 30 : phone.w*0.8)
        }
    }
}

struct ControlTabView: View {
    @StateObject var model: LayoutModel
    @Binding var status: ShapeConfiguration
    @Binding var tabMode: String
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    var body: some View {
        if tabMode == "Home" {
            HomeTab(model: model)
        } else if tabMode == "EditShape" {
            EditShapeTab(model: model, status: $status)
        } else if tabMode == "MoveShape" {
            MoveShapeTab(model: model, status: $status)
        } else if tabMode == "MiniMap" {
            MiniMapTab(model: model)
        } else if tabMode == "SummonTab" {
            SummonEditTab(model: model)
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
        VStack(spacing: 15) {
            HStack(spacing: 15) {
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
            HStack(spacing: 15) {
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
            
            HStack{
                
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
    }
}

struct EditShapeTab: View {
    @StateObject var model: LayoutModel
    @Binding var status: ShapeConfiguration
    var body: some View {
        ZStack {
            editButtons
        }
    }
    var editButtons: some View {
        VStack {
            editStyle
            editColor
            editSize
            ZStack {
                Spacer()
                    .frame(height: 35)
                if status.style == "Rectangle" {
                    editCorner
                } else if status.style == "Text" {
                    editText
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
    }
    
    let StyleList = ["Rectangle", "Circle", "Ellipse", "Text"]
    var editStyle: some View {
        HStack(spacing: 5) {
            ForEach(StyleList, id: \.self){ style in
                Button(action: {
                    status.style = style
                }) {
                    editStyleButtons(style: style)
                }
            }
        }
    }
    var editColor: some View {
        selectColoriew(status: $status.color, changeStatus: "", small: true)
            .frame(width: phone.w/2.2)
    }
    var editSize: some View {
        VStack(spacing: 0) {
            Text("W: \(String(format: "%.0f", status.size.width))    H: \(String(format: "%.0f", status.size.height))")
            Slider(value: $status.size.width, in: 1...phone.w*1.1)
                .frame(width: phone.w/2.2)
            Slider(value: $status.size.height, in: 1...phone.h*1.1)
                .frame(width: phone.w/2.2)
        }
    }
    var editCorner: some View {
        HStack {
            Text("丸さ \(String(format: "%.0f", status.corner))")
                .foregroundColor(Color.black)
                .frame(width: phone.w/6, alignment: .leading)
            Slider(value: $status.corner, in: 0...99)
                .frame(width: phone.w/4)
        }
    }
    var editText: some View {
        TextField("テキストを入力", text: $status.text.character)
            .frame(width: phone.w/2.2, height: 30)
            .border(Color.gray)
    }
}

struct MoveShapeTab: View {
    @StateObject var model: LayoutModel
    @Binding var status: ShapeConfiguration
    @State var distance = 10
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("X : \(String(format: "%.1f", status.position.x))")
                        .frame(width: phone.w/4, alignment: .leading)
                    Text("Y : \(String(format: "%.1f", status.position.y))")
                        .frame(width: phone.w/4, alignment: .leading)
                }
                Spacer()
                VStack {
                    Button(action: {}){
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 60, height: 20)
                            .overlay(Text("AUTO +")
                                .font(.caption)
                                .foregroundColor(Color.white))
                    }
                    HStack {
                        Button(action: {distance-=1}){
                            Text("-")
                        }
                        Text("\(distance)")
                            .frame(width: 25)
                        Button(action: {distance+=1}){
                            Text("+")
                        }
                    }
                }
            }
            VStack(spacing: 0){
                Button(action: {
                    model.moveShape(direction: "y-", distance: distance)
                }){
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                HStack {
                    Button(action: {
                        model.moveShape(direction: "x-", distance: distance)
                    }){
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    Spacer().frame(width: 50, height: 50)
                    Button(action: {
                        model.moveShape(direction: "x+", distance: distance)
                    }){
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
                Button(action: {
                    model.moveShape(direction: "y+", distance: distance)
                }){
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            Text("端末").frame(width: phone.w/2.2, alignment: .leading)
            HStack {
                Text("横: \(String(format: "%.1f", phone.w)) x 縦: \(String(format: "%.1f", phone.h))")
            }
        }.frame(width: phone.w/2.2, height: 30)
    }
}

struct MiniMapTab: View {
    @StateObject var model: LayoutModel
    @State var reduction = CGFloat(3.5)
    var body: some View {
        VStack {
            LayoutMiniMap(layout: $model.shapeArray, model: model, reduction: reduction)
        }
    }
}

struct SummonEditTab: View {
    @StateObject var model: LayoutModel
    let btnName = ButtonName()
    let buttons1 = ["サイズ","フレーム","シャドウ"]
    let buttons2 = ["回転","カラー","閉じる"]
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: phone.w/2.1, height: 30)
                    .foregroundColor(Color(red: 0, green: 0, blue: 0.5, opacity: 0.8))
                    .overlay(
                        Text("ミニウィンドウの呼び出し")
                            .font(.custom("Hiragino Sans", size: 13).weight(.bold))
                            .foregroundColor(Color.white)
                    )
                
                HStack(spacing: 15) {
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
                HStack(spacing: 15) {
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



//Shape(status: $status, reduction: 1)
//    .foregroundColor(Color(red: status.frame.color.r, green: status.frame.color.g,
//                           blue: status.frame.color.b, opacity: status.frame.color.o))
//.frame(width: status.size.width + status.frame.width + status.frame.width,
//       height: status.size.height + status.frame.width + status.frame.width)
//.shadow(color: Color(red: status.shadow.color.r, green: status.shadow.color.g,
//                     blue: status.shadow.color.b, opacity: status.shadow.color.o),
//        radius: status.shadow.radius,
//        x: status.shadow.x,
//        y: status.shadow.y)
//.overlay(
//    // 図の描画
//    Shape(status: $status, reduction: 1)
//        .frame(width: status.size.width, height: status.size.height)
//        .foregroundColor(Color(red: status.color.r, green: status.color.g,
//                               blue: status.color.b, opacity: status.color.o))
//        .opacity(status.opacity)
//)
//.rotationEffect(Angle(degrees: status.rotation))
//
//.position(status.position)
