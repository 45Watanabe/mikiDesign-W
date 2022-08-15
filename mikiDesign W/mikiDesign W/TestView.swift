//
//  TestView.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/11.
//

import SwiftUI

struct TestView: View {
//    @State var shapeColor: UIColor = UIColor(red: 0.5, green: 0.5, blue: 1, alpha: 1)
    @State var shapeColor: Color = Color(red: 0.7, green: 0.5, blue: 0.8, opacity: 1.0)
    @State var selectedColor: Color = Color.red
    @StateObject var vm = LayoutModel()
    var body: some View {
        VStack {
            ScrollView(.horizontal){
                HStack {
                    ForEach(ColorList.defaultColorList, id: \.self){ color in
                        RoundedRectangle(cornerRadius: 1)
                            .frame(width: 50, height: 50)
                            .foregroundColor(color)
                    }
                }
            }
            
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 100, height: 200)
                .foregroundColor(shapeColor)
            
            ColorPicker("Select Color", selection: $selectedColor)
                .frame(width: 200)
                .border(Color.black)
                .onDisappear(){
                    print("AAAA")
                }
            
            Button(action: {
                print(shapeColor)
                let text: [String] = "\(selectedColor)".components(separatedBy: " ")
                var colors: [CGFloat] = []
                for i in 1...4 {
                    colors.append(CGFloat(Double(text[i])!))
                }
                print(colors)
                shapeColor=Color(red: colors[0],
                                 green: colors[1],
                                 blue: colors[2],
                                 opacity: colors[3])
                
                print(shapeColor)
            }){
                Text("SINK")
            }
            
            Button(action: {
                let text: [String] = "\(selectedColor)".components(separatedBy: " ")
                var colors: [CGFloat] = []
                for i in 1...4 {
                    colors.append(CGFloat(Double(text[i])!))
                }
                print(colors)
                shapeColor=Color(red: colors[0],
                                 green: colors[1],
                                 blue: colors[2],
                                 opacity: colors[3])
                
                print("\(shapeColor)")
            }){
                Text("PRINT")
            }
            
            Button(action: {
                var code = "CDCDFBFF"
                var array: [CGFloat] = []
                for _ in 0...3 {
                    array.append(CGFloat(Int("\(code.prefix(2))", radix: 16)!)/255)
                    code.removeFirst(2)
                }
                print(array)
                shapeColor = Color(red: array[0], green: array[1], blue: array[2], opacity: array[3])
                print(shapeColor)
            }){
                Text("TEST")
            }
        }
        
        //                0.62522, 0.489178, 0.15646
        //                print(CGFloat(Int("9F", radix: 16)!)/255)
        //                print(CGFloat(Int("7D", radix: 16)!)/255)
        //                print(CGFloat(Int("28", radix: 16)!)/255)
        //                print(CGFloat(Int("FF", radix: 16)!)/255)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
