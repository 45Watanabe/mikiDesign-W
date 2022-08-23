//
//  EditView.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/10.
//

import SwiftUI

struct EditView: View {
    @StateObject var model: LayoutModel
    @Binding var status: ShapeConfiguration
    @State var isSelectFont = false
    @State var isSelectSymbol = false
    @State var changeColor = "main"
    @State var isFrameColorEdit = false
    @State var isShadowColorEdit = false
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            ShapeView(status: $status)
                .position(status.position)
            
            Button(action: {return}){
                Rectangle()
                    .frame(width: status.size.width,
                           height: status.size.height)
                    .position(status.position)
                    .opacity(0.0)
            }
            
            VStack {
                Button(action: {
                    model.editMode(isMove: false)
                    dismiss()
                }){
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 40)
                        .overlay(
                            Text("CLOSE")
                            .font(.title2)
                            .foregroundColor(Color.white))
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                Rectangle()
                    .frame(width: phone.w, height: 1)
                    .padding(5)
                ZStack {
                    editButtons.frame(width: phone.w, height: phone.h/2)
                    if isSelectFont {fontListView(status: $status)}
                    if isSelectSymbol {SFSymbolsList(status: $status)}
                }
            }
            
            // fontList表示ボタン
            HStack {
                Spacer().frame(width: phone.w*0.85)
                VStack {
                    Button(action: {
                        isSelectFont.toggle()
                    }){
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: phone.w/10, height: phone.w/10)
                            .foregroundColor(Color.white)
                            .overlay(
                                Image(systemName: "f.square")
                                    .resizable()
                                    .frame(width: phone.w/10, height: phone.w/10)
                                    .foregroundColor(Color.black)
                            )
                    }
                    Button(action: {
                        isSelectSymbol.toggle()
                    }){
                        Image("iconImage")
                            .resizable()
                            .frame(width: phone.w/10, height: phone.w/10)
                    }
                }
            }
        }.background(Color.white)
    }
    
    var editButtons: some View {
        // 設定ボタンリスト
            ScrollView {
                Spacer().frame(width: phone.w*0.85)
                Group {
                    selectStyleView(status: $status)
                    selectColoriew(status: $status.color, changeStatus: "", small: false)
                    editSizeView(status: $status)
                    editCornerView(status: $status)
                    editTextView(status: $status)
                }
                Group {
                    editFrameView(status: $status, isColorEdit: $isFrameColorEdit)
                    if isFrameColorEdit{selectColoriew(status: $status.frame.color,
                                                       changeStatus: "フレーム", small: false)}
                    editShadowView(status: $status, isColorEdit: $isShadowColorEdit)
                    if isShadowColorEdit{selectColoriew(status: $status.shadow.color,
                                                        changeStatus: "シャドウ", small: false)}
                    editRotationView(status: $status)
                }
                
            }
            .frame(width: phone.w*0.85)
            .padding(.trailing, phone.w*0.15)
        
    }
    
}

struct selectStyleView: View {
    @Binding var status: ShapeConfiguration
    let StyleList = ["Rectangle", "Circle", "Ellipse", "Text", "SFSymbols"]
    var body: some View {
        ZStack {
            BaseRectangle(size: CGSize(width:  phone.w*0.8, height: phone.w*0.2), text: "スタイル")
            HStack(spacing: 5) {
                ForEach(StyleList, id: \.self){ style in
                    Button(action: {
                        status.style = style
                    }) {
                        editViewStyleButtons(style: style)
                    }
                }
            }
        }
    }
}

struct editSizeView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        ZStack {
            BaseRectangle(size: CGSize(width:  phone.w*0.8, height: phone.w*0.3), text: "サイズ")
            VStack(spacing: 0) {
                SliderView(text: "W", width: phone.w*0.4, min: 1, max: phone.w*1.1, value: $status.size.width)
                Button(action: {
                    
                }){
                    Image(systemName: "lock.open") //lock .frame(width: 10, height: 15)
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.black)
                        .padding(.trailing, phone.w*0.6)
                }
                SliderView(text: "H", width: phone.w*0.4, min: 1, max: phone.h*1.1, value: $status.size.height)
            }
        }
    }
}

struct editCornerView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        if status.style == "Rectangle" {
            ZStack {
                BaseRectangle(size: CGSize(width:  phone.w*0.8, height: phone.w*0.15), text: "コーナー")
                HStack {
                    SliderView(text: "丸さ", width: phone.w*0.4, min: 0, max: 99, value: $status.corner)
                }
            }
        }
    }
}

struct editTextView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        if status.style == "Text" {
            ZStack {
                BaseRectangle(size: CGSize(width:  phone.w*0.8, height: phone.w*0.3), text: "テキスト")
                VStack {
                    HStack {
                        TextField("テキストを入力", text: $status.text.character)
                            .frame(width: phone.w*0.75, height: 30)
                            .border(Color.gray)
                    }
                    
                    HStack {
                        SliderView(text: "サイズ", width: phone.w*0.2, min: 1, max: 99, value: $status.text.size)
                        
                        Button(action: {}){
                            Image(systemName: "f.square")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.leading, 10)
                        }
                    }
                }
            }
        }
    }
}

struct editFrameView: View {
    @Binding var status: ShapeConfiguration
    @Binding var isColorEdit: Bool
    var body: some View {
        ZStack {
            BaseRectangle(size: CGSize(width:  phone.w*0.8, height: phone.w*0.25), text: "フレーム")
            HStack {
                Group {
                    VStack {
                        FluctuationButton(text: "幅", addIs1: true, value: $status.frame.width)
                        Text("色の変更")
                            .background(Color.gray)
                            .onTapGesture { isColorEdit.toggle() }
                    }
                }
                Group {
                    FluctuationButton(text: "透明", addIs1: false, value: $status.frame.opacity)
                }
            }
        }
    }
}

struct editShadowView: View {
    @Binding var status: ShapeConfiguration
    @Binding var isColorEdit: Bool
    var body: some View {
        ZStack {
            BaseRectangle(size: CGSize(width:  phone.w*0.8, height: phone.w*0.25), text: "シャドウ")
            HStack {
                VStack {
                    FluctuationButton(text: "ぼかし", addIs1: true, value: $status.shadow.radius)
                    Text("色の変更")
                        .background(Color.gray)
                        .onTapGesture { isColorEdit.toggle() }
                }
                Spacer().frame(width: phone.w/15)
                VStack {
                    Group {
                        FluctuationButton(text: "X", addIs1: true, value: $status.shadow.x)
                        FluctuationButton(text: "Y", addIs1: true, value: $status.shadow.y)
                    }
                }
            }
        }
    }
}

struct editRotationView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        ZStack {
            BaseRectangle(size: CGSize(width:  phone.w*0.8, height: phone.w*0.3), text: "ローテーション")
            VStack {
                Spacer().frame(height: 10)
                HStack {
                    Text("\(String(format: "%.0f", status.rotation))°")
                        .frame(width: 70, alignment: .leading)
                    VStack {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<25){ i in
                                    Button(action: {
                                        status.rotation = Double(15*i)
                                    }){
                                         Text("\(15*i)°")
                                            .font(.title2)
                                    }
                                }
                            }
                        }.frame(width: phone.w*0.5)
                    }
                }
                
                HStack {
                    Image(systemName: "minus.rectangle")
                        .resizable()
                        .frame(width: phone.w/20, height: phone.w/20)
                        .onTapGesture { status.rotation-=1 }
                    
                    Slider(value: $status.rotation, in: 0...360)
                        .frame(width: phone.w*0.6)
                    
                    Image(systemName: "plus.rectangle")
                        .resizable()
                        .frame(width: phone.w/20, height: phone.w/20)
                        .onTapGesture { status.rotation+=1 }
                }
                
            }
        }
    }
}

struct fontListView: View {
    @Binding var status: ShapeConfiguration
    var names: [String] = UIFont.familyNames
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.white.opacity(0.95))
            ScrollView {
                Spacer().frame(height: 10)
                ForEach(names, id: \.self){ name in
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: phone.w*0.8, height: 50)
                            .foregroundColor(status.text.font == name ?
                                             Color.gray.opacity(0.2) : Color.white)
                            .shadow(color: Color.gray, radius: 5, x: 0, y: 0)
                            .onTapGesture { status.text.font = name }
                        
                        Text("  テキスト : \(name)")
                            .font(.custom(name, size: 15))
                            .frame(width: phone.w*0.8, height: 20,
                                   alignment: .leading)
                            .padding()
                    }
                }
                Spacer().frame(height: phone.w/3)
            }
        }.frame(width: phone.w*0.85, height: phone.h/2)
            .padding(.trailing, phone.w*0.15)
    }
}

struct editViewStyleButtons: View {
    @State var style: String
    var body: some View {
        Group{
            if style == "Rectangle" {
                RoundedRectangle(cornerRadius: 0)
                    .frame(width: phone.w/10, height: phone.w/10)
            } else if style == "Circle" {
                Capsule()
                    .frame(width: phone.w/9, height: phone.w/9)
            } else if style == "Ellipse" {
                Ellipse()
                    .frame(width: phone.w/9, height: phone.w/12)
            } else if style == "Text" {
                Image(systemName: "t.square")
                    .resizable()
                    .frame(width: phone.w/10, height: phone.w/10)
            } else if style == "SFSymbols" {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 3)
                    .frame(width: phone.w/10, height: phone.w/10)
                    .overlay(
                        Text("SF")
                            .font(.custom("default", size: phone.w/20))
                    )
            }
        }.foregroundColor(Color.black)
    }
}
