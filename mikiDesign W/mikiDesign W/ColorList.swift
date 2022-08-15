//
//  ColorList.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/12.
//

import SwiftUI

struct selectColoriew: View {
    @ObservedObject var cl: ColorList = .colorList
    @Binding var status: Color
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
                ForEach(ColorList.defaultColorList, id: \.self){ color in
                    ColorCell(status: $status, color: color, size: small ? phone.w/15 : phone.w/10)
                }
            }
        }.frame(width: small ? phone.w/2.2 :  phone.w*0.75)
    }
    var userColor: some View {
        ScrollView(.horizontal){
            HStack(spacing: 2) {
                ForEach(cl.userColorList, id: \.self){ color in
                    ColorCell(status: $status, color: color, size: small ? phone.w/15 : phone.w/10)
                }
            }
        }.frame(width: small ? phone.w/3 :  phone.w*0.55)
            .padding(.trailing, small ? phone.w/2.2-phone.w/3 :  phone.w*0.2)
    }
}

struct ColorCell: View {
    @Binding var status: Color
    @State var color: Color
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
                        .foregroundColor(Color.black)
                        .rotationEffect(Angle(degrees: 45))
                )
                .overlay(
                    Rectangle()
                        .frame(width: size, height: size)
                        .foregroundColor(color)
                )
        }
    }
}

class ColorList: ObservableObject {
    static let colorList = ColorList()
    static let defaultColorList: [Color] = [
        Color(red: 1, green: 0, blue: 0, opacity: 1), // 赤
        Color(red: 1, green: 0.7, blue: 1, opacity: 1), // 桃
        Color(red: 1, green: 0.55, blue: 0.3, opacity: 1), // 橙
        Color(red: 0.95, green: 0.8, blue: 0.25, opacity: 1), // 黄
        Color(red: 0.55, green: 0, blue: 1, opacity: 1), // 紫
        Color(red: 0, green: 0, blue: 1, opacity: 1), // 青
        Color(red: 0, green: 1, blue: 0, opacity: 1), // 緑
        Color(red: 0, green: 0, blue: 0, opacity: 1), // 黒
        Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 1), // 灰
        Color(red: 1, green: 1, blue: 1, opacity: 1), // 白
        Color(red: 0, green: 1, blue: 0, opacity: 0)  // 透明
    ]
    @Published var userColorList: [Color] = []
    
    init() {
        getColorList()
    }
    
    func getColorList() {
        let userCL: [String] = UserDefaults.standard.stringArray(forKey: "追加カラーリスト") ?? ["#CDCDFBFF"]
        for colorCode in userCL {
            var code = colorCode.suffix(8)
            var array: [CGFloat] = []
            for _ in 0...3 {
                array.append(CGFloat(Int("\(code.prefix(2))", radix: 16)!)/255)
                code.removeFirst(2)
            }
            userColorList.append(
                Color(red: array[0], green: array[1], blue: array[2], opacity: array[3])
            )
        }
    }
    
    func addColor(colorStr: String) {
        if colorStr.prefix(1) != "#" {
            let array = colorStr.components(separatedBy: " ")
            let newColor = Color(red: CGFloat(Double(array[1])!), green: CGFloat(Double(array[2])!),
                                 blue: CGFloat(Double(array[3])!), opacity: CGFloat(Double(array[4])!))
            userColorList.insert(newColor, at: 0)
        }
        saveColor()
    }
    
    func saveColor() {
        var array: [String] = []
        for color in userColorList {
            array.append("\(color)")
        }
        UserDefaults.standard.set(array, forKey: "追加カラーリスト")
    }
}

