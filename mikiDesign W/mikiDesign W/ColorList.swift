//
//  ColorList.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/12.
//

import SwiftUI

struct selectColoriew: View {
    @ObservedObject var cl: ColorList = .colorList
    @Binding var status: SColor
    let changeStatus: String
    let small: Bool
    @State var newColor = Color(red: 1.0, green: 0, blue: 0, opacity: 1)
    
    var body: some View {
        ZStack {
            if !small {
                BaseRectangle(size: CGSize(width:  phone.w*0.8, height: phone.w*0.3), text: "\(changeStatus)カラー")
            }
            VStack {
                colorButtons
                ZStack {
                    userColor
                    ColorPicker("", selection: $newColor)
                        .frame(width: small ? phone.w/2.2 :phone.w*0.75, alignment: .trailing)
                    Button(action: {
                        cl.addColor(colorStr: "\(newColor)")
                    }){
                        BaseRectangle(size: CGSize(width:  small ? phone.w/15 : phone.w/10,
                                                   height: small ? phone.w/15 : phone.w/10), text: "")
                            .overlay(
                                Image(systemName: "plus.square")
                                    .resizable()
                                    .frame(width: small ? phone.w/18 : phone.w/12,
                                           height: small ? phone.w/18 : phone.w/12)
                                    .foregroundColor( "\(newColor)".prefix(1) == "#" ?
                                                      Color.clear : newColor)
                            )
                    }.frame(width: small ? phone.w/3.3 : phone.w*0.55, alignment: .trailing)
                }
            }
        }
    }
    var colorButtons: some View {
        ScrollView(.horizontal){
            HStack(spacing: 2) {
                ForEach(ColorList.defaultColorList){ color in
                    ColorCell(status: $status, color: color, size: small ? phone.w/15 : phone.w/10)
                }
            }
        }.frame(width: small ? phone.w/2.2 :  phone.w*0.75)
    }
    var userColor: some View {
        ScrollView(.horizontal){
            HStack(spacing: 2) {
                ForEach(cl.userColorList){ color in
                    ColorCell(status: $status, color: color, size: small ? phone.w/15 : phone.w/10)
                }
            }
        }.frame(width: small ? phone.w/3 :  phone.w*0.55)
            .padding(.trailing, small ? phone.w/2.2-phone.w/3 :  phone.w*0.2)
    }
}

struct ColorCell: View {
    @Binding var status: SColor
    @State var color: SColor
    let size: CGFloat
    var body: some View {
        Button(action: {
            status = color
        }){
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(width: size + 1, height: size + 1)
                .foregroundColor(Color.gray)
                .overlay(
                    Rectangle()
                        .frame(width: 1, height: size*1.2)
                        .foregroundColor(Color.black.opacity(0.3))
                        .rotationEffect(Angle(degrees: 45))
                )
                .overlay(
                    Rectangle()
                        .frame(width: size, height: size)
                        .foregroundColor(Color(red: color.r, green: color.g,
                                               blue: color.b, opacity: color.o))
                )
        }
    }
}

class ColorList: ObservableObject {
    static let colorList = ColorList()
    static let defaultColorList: [SColor] = [
        SColor(r: 1, g: 0, b: 0, o: 1), // 赤
        SColor(r: 1, g: 0.7, b: 1, o: 1), // 桃
        SColor(r: 1, g: 0.55, b: 0.3, o: 1), // 橙
        SColor(r: 0.95, g: 0.8, b: 0.25, o: 1), // 黄
        SColor(r: 0.55, g: 0, b: 1, o: 1), // 紫
        SColor(r: 0, g: 0, b: 1, o: 1), // 青
        SColor(r: 0, g: 1, b: 0, o: 1), // 緑
        SColor(r: 0, g: 0, b: 0, o: 1), // 黒
        SColor(r: 0.5, g: 0.5, b: 0.5, o: 1), // 灰
        SColor(r: 1, g: 1, b: 1, o: 1), // 白
        SColor(r: 0, g: 1, b: 0, o: 0)  // 透明
    ]
    @Published var userColorList: [SColor] = []
    
    init() {
        getColorList()
    }
    
    func getColorList() {
        let userCL: [String] = UserDefaults.standard.stringArray(forKey: "追加カラーリスト") ?? ["#CDCDFBFF"]
        for colorCode in userCL {
            if colorCode.prefix(1) == "#" {
                var code = colorCode.suffix(8)
                var array: [CGFloat] = []
                for _ in 0...3 {
                    array.append(CGFloat(Int("\(code.prefix(2))", radix: 16)!)/255)
                    code.removeFirst(2)
                }
                userColorList.append(
                    SColor(r: array[0], g: array[1], b: array[2], o: array[3])
                )
            }
        }
    }
    
    func addColor(colorStr: String) {
        if colorStr.prefix(1) != "#" {
            let array = colorStr.components(separatedBy: " ")
            let newColor = SColor(r: CGFloat(Double(array[1])!), g: CGFloat(Double(array[2])!),
                                 b: CGFloat(Double(array[3])!), o: CGFloat(Double(array[4])!))
            userColorList.insert(newColor, at: 0)
        }
        saveColor()
    }
    
    func saveColor() {
        var array: [String] = []
        for color in userColorList {
            let userColor = Color(red: color.r, green: color.g, blue: color.b, opacity: color.o)
            array.append("\(userColor)")
        }
        UserDefaults.standard.set(array, forKey: "追加カラーリスト")
    }
}

