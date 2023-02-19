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
    @State var isSelectImage = false
    @State var isSelectCode = false
    @State var changeColor = "main"
    @State var isFrameColorEdit = false
    @State var isShadowColorEdit = false
    @State var bgColor = Color.white
    let bgColorList: [Color] = [.white, .gray, .black]
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
                VStack {
                    Rectangle()
                        .frame(width: phone.w, height: 1)
                        .padding(0)
                        .background(Color.white)
                    
                    ZStack {
                        editButtons.frame(width: phone.w, height: phone.h/2)
                        if isSelectFont {fontListView(status: $status)}
                        if isSelectSymbol {SFSymbolsList(status: $status)}
//                        if isSelectImage {imageSelectView(status: $status, model: model)}
                        if isSelectCode {swiftCodeView(status: $status)}
                    }
                }
                .background(Color.white)
            }
            
            // モード変更ボタン
            HStack {
                Spacer().frame(width: phone.w*0.85)
                VStack {
                    Button(action: {
                        isSelectSymbol = false
                        isSelectImage = false
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
                        isSelectFont = false
                        isSelectImage = false
                        isSelectSymbol.toggle()
                    }){
                        Image("iconImage")
                            .resizable()
                            .frame(width: phone.w/10, height: phone.w/10)
                    }
                    Button(action: {
                        isSelectFont = false
                        isSelectSymbol = false
                        isSelectCode.toggle()
                    }){
                        Image(systemName: "swift")
                            .resizable()
                            .frame(width: phone.w/10, height: phone.w/10)
                    }
                    Spacer()
                }
            }
            .padding(.top, phone.h/2)
            
            // 背景色の変更
            HStack{
                Spacer().frame(width: 10)
                VStack{
                    Spacer().frame(height: 100)
                    ForEach(bgColorList, id: \.self){ color in
                        Button(action: {
                            bgColor = color
                        }){
                            Rectangle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(color)
                        }
                    }
                    
                    Spacer()
                }
                Spacer()
            }
            
        }
        .background(bgColor)
        .animation(.default, value: bgColor)
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
                    editShadowView(status: $status, isColorEdit: $isShadowColorEdit)
                    editRotationView(status: $status)
                    editOpacityView(status: $status)
//                    swiftCodeView(status: $status)
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
                SliderView(text: "W", width: phone.w*0.4, min: 1, max: phone.h*1.1, value: $status.size.width)
                Button(action: {
                    status.size.height = status.size.width
                }){
                    Image(systemName: "arrow.down") //lock .frame(width: 10, height: 15)
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
            BaseRectangle(size: CGSize(width:  phone.w*0.8, height: isColorEdit ? phone.w*0.5 : phone.w*0.25), text: "フレーム")
            VStack {
                HStack {
                    Group {
                        VStack {
                            FluctuationButton(text: "幅", addIs1: true, value: $status.frame.width)
                            HStack {
                                Text("カラーパレット")
                                    .foregroundColor(Color.black)
                                Button(action: {
                                    isColorEdit.toggle()
                                }, label: {
                                    Image(systemName: isColorEdit ? "chevron.up.square.fill" : "chevron.down.square.fill")
                                        .resizable()
                                        .frame(width: phone.w/20, height: phone.w/20)
                                })
                            }
                        }
                    }
                    Group {
                        FluctuationButton(text: "透明", addIs1: false, value: $status.frame.opacity)
                    }
                }
                if isColorEdit {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: phone.w*0.7, height: 1)
                        .foregroundColor(Color.gray.opacity(0.5))
                    selectColoriew(status: $status.frame.color, changeStatus: "フレーム", small: false)
                }
            }.animation(.default, value: isColorEdit)
        }.animation(.default, value: isColorEdit)
    }
}

struct editShadowView: View {
    @Binding var status: ShapeConfiguration
    @Binding var isColorEdit: Bool
    var body: some View {
        ZStack {
            BaseRectangle(size: CGSize(width:  phone.w*0.8, height: isColorEdit ? phone.w*0.5 : phone.w*0.25), text: "シャドウ")
            VStack {
                HStack {
                    VStack(spacing: 5) {
                        FluctuationButton(text: "ぼかし", addIs1: true, value: $status.shadow.radius)
                        HStack {
                            Text("カラーパレット")
                                .foregroundColor(Color.black)
                            Button(action: {
                                isColorEdit.toggle()
                            }, label: {
                                Image(systemName: isColorEdit ? "chevron.up.square.fill" : "chevron.down.square.fill")
                                    .resizable()
                                    .frame(width: phone.w/20, height: phone.w/20)
                            })
                        }
                    }
                    Spacer().frame(width: phone.w/15)
                    VStack {
                        Group {
                            FluctuationButton(text: "X", addIs1: true, value: $status.shadow.x)
                            FluctuationButton(text: "Y", addIs1: true, value: $status.shadow.y)
                        }
                    }
                }
                if isColorEdit {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: phone.w*0.7, height: 1)
                        .foregroundColor(Color.gray.opacity(0.5))
                    selectColoriew(status: $status.shadow.color, changeStatus: "シャドウ", small: false)
                }
            }.animation(.default, value: isColorEdit)
        }.animation(.default, value: isColorEdit)
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
                                ForEach(-24..<25){ i in
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
                    
                    Slider(value: $status.rotation, in: -360...360)
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
    @State var names: [String] = UIFont.familyNames
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
                        if name.prefix(8) == "Hiragino" {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 1)
                                .frame(width: phone.w*0.8, height: 50)
                                .foregroundColor(Color.red)
                        }
                        
                        Text("  文字サンプル : \(name)")
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
            .onAppear(){ setList() }
            
    }
    func setList() {
        names = UIFont.familyNames
        let japaneseFonts = ["Hiragino Maru Gothic ProN", "Hiragino Mincho ProN", "Hiragino Sans"]
        for japaneseFont in japaneseFonts {
            names.insert(japaneseFont, at: 0)
        }
        print(names)
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

struct imageSelectView: View {
    @Binding var status: ShapeConfiguration
    @StateObject var model: LayoutModel
    var body: some View {
        if status.style != "Image" {
            imageEditView(status: $status, model: model)
        } else {
            ZStack {
                backGround
                VStack {
                    Button(action: {
                        // 画像の追加
                        // 選択を配列最終に
                    }, label: {
                        Image(systemName: "plus.app")
                    })
                }
            }
            .frame(width: phone.w*0.85, height: phone.h/2)
            .padding(.trailing, phone.w*0.15)
        }
    }
    var backGround: some View {
        VStack(spacing: phone.w*0.2) {
                ForEach(0..<7){ _ in
                    HStack {
                        ForEach(0..<7){ _ in
                            Image(systemName: "lock.fill")
                                .foregroundColor(Color.black)
                            Rectangle()
                                .frame(width: phone.w*0.2, height: 1)
                                .foregroundColor(Color.black)
                        }
                    }
                    .rotationEffect(Angle(degrees: 45))
                }
        }
        .background(Color.white)
        .frame(width: phone.w*0.85, height: phone.h/2)
        .padding(.trailing, phone.w*0.15)
        .clipped()
    }
}

struct editOpacityView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        ZStack {
            BaseRectangle(size: CGSize(width:  phone.w*0.8, height: phone.w*0.15), text: "オパシティ")
            HStack {
                HStack {
                    Text("透明度: \(String(format: "%.1f", status.opacity))")
                        .frame(width: 90, alignment: .leading)
                    
                    Image(systemName: "minus.rectangle")
                        .resizable()
                        .frame(width: phone.w/20, height: phone.w/20)
                        .onTapGesture { status.opacity-=0.1 }
                    
                    Slider(value: $status.opacity, in: 0.1...1.0)
                        .frame(width: phone.w/3)
                    
                    Image(systemName: "plus.rectangle")
                        .resizable()
                        .frame(width: phone.w/20, height: phone.w/20)
                        .onTapGesture { status.opacity+=0.1 }
                }
            }
        }
    }
}

struct swiftCodeView: View {
    @Binding var status: ShapeConfiguration
    @State var code = ""
    var body: some View {
        ZStack {
            
                Text(code)
                .foregroundColor(Color.black)
                .font(.custom("", size: 10))
                .padding(phone.w*0.05)
                
        }
        .onAppear(){ generateCode() }
        .frame(width: phone.w*0.85, height: phone.h/2)
            .padding(.trailing, phone.w*0.15)
        .background(Color.white)
    }
    func generateCode() {
        var padding = ""
        // フレームの有無
        if status.frame.color.o > 0 && status.frame.width > 0 && status.frame.opacity > 0 {
            code += "ZStack {\n"
            padding = "  "
            
        }
        code += padding
        switch status.style {
        case "Rectangle": code += "RoundedRectangle(cornerRadius: \(String(format: "%.0f", status.corner)))\n"
        case "Circle": code += "Capsule()\n"
        case "Ellipse": code += "Ellipse()\n"
        case "Text": code += "Text(\"\(status.text.character)\")\n  .font(.custom(\(status.text.font), size: \(status.text.size)))\n"
        case "SFSymbols": code += " Image(systemName: \(status.symbolName)\n  .resizable()\n"
        default:  code += "Shape()\n"
        }
        padding += "  "
        code += padding
        code += ".frame(width: \(String(format: "%.0f", status.size.width)), height: \(String(format: "%.0f", status.size.height)))\n"
        code += padding
        code += ".foregroundColor(Color(red: \(status.color.r), green: \(status.color.g), blue: \(status.color.b), opacity: \(status.color.o)))\n"
        if status.opacity < 1 {
            code += padding
            code += ".opacity(\(String(format: "%.2f", status.opacity)))\n"
        }
        
        if status.frame.color.o > 0 && status.frame.width > 0 && status.frame.opacity > 0 {
            padding = ""
            code += "}\n"
        }
        
        if status.shadow.color.o > 0 {
            code += padding
            code += ".shadow(color: Color(red: \(status.shadow.color.r), green: \(status.shadow.color.g), blue: \(status.shadow.color.b), opacity: \(status.shadow.color.o)),\n"
            code += padding
            code += "        radius: \(String(format: "%.0f", status.shadow.radius)), x: \(String(format: "%.0f", status.shadow.x)), y: \(String(format: "%.0f", status.shadow.y)))\n"
        }
        
        if Int(status.rotation) != 0 {
            code += padding
            code += ".rotationEffect(Angle(degrees: \(String(format:"%.0f",status.rotation)))\n"
        }
        
        code += padding
        code += ".position(x: \(String(format: "%.0f",status.position.x)), y: \(String(format: "%.0f",status.position.y)))"
    }
}

struct imageEditView: View {
    @Binding var status: ShapeConfiguration
    @StateObject var model: LayoutModel
    @ObservedObject var manager: ImageManager = .imageManager
    @State var showingImagePicker = false
    @State private var image: UIImage? = UIImage(systemName: "house")
    @State var newKey = UUID().uuidString
    @State var mode = "selectImageInDefault"
    @State var shadowIsColorEdit = false
    @State var frameIsColorEdit = false
    let columns = [GridItem(.fixed(phone.w*0.25)),GridItem(.fixed(phone.w*0.25)),GridItem(.fixed(phone.w*0.25))]
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    mode = "selectImageInDefault"
                }, label: {
                    Image(systemName: "iphone")
                })
                Button(action: {
                    mode = "selectImageInStrage"
                    manager.printAllKey()
                }, label: {
                    Image(systemName: "iphone")
                })
                Button(action: {
                    mode = "editimage"
                }, label: {
                    Image(systemName: "iphone")
                })
            }
            if mode == "selectImageInDefault" {
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns) {
                        ForEach(manager.keyList, id: \.self){ key in
                            DispImage(key: key)
                        }
                    }
                }
                .frame(width: phone.w*0.85, height: phone.h/2.2)
            } else if mode == "selectImageInStrage" {
                ZStack {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns) {
                            ForEach(manager.keyList, id: \.self){ key in
                                DispImage(key: key)
                            }
                        }
                    }
                    Image(systemName: "plus.app")
                        .resizable()
                        .frame(width: phone.w*0.1, height: phone.w*0.1)
                        .padding(.top, phone.h/2.5)
                        .padding(.leading, phone.w*0.75)
                }
                .frame(width: phone.w*0.85, height: phone.h/2.2)
            } else if mode == "editimage" {
                ScrollView(.vertical) {
                    editSizeView(status: $status)
                    editFrameView(status: $status, isColorEdit: $frameIsColorEdit)
                    editShadowView(status: $status, isColorEdit: $shadowIsColorEdit)
                    editRotationView(status: $status)
                    editOpacityView(status: $status)
                    
                }
                .frame(width: phone.w*0.85, height: phone.h/2.2)
            }
        }
        .frame(width: phone.w*0.85, height: phone.h/2)
        .padding(.trailing, phone.w*0.15)
        .background(Color.white)
        .animation(.default, value: mode)
    }
}
