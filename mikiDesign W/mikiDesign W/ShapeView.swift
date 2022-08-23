//
//  ShapeView.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/10.
//

import SwiftUI

struct ShapeView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        // 縁の描画
        Shape(status: $status)
            .foregroundColor(Color(red: status.frame.color.r, green: status.frame.color.g,
                                   blue: status.frame.color.b, opacity: status.frame.color.o))
        .frame(width: status.size.width + status.frame.width + status.frame.width,
               height: status.size.height + status.frame.width + status.frame.width)
        .opacity(status.frame.opacity)
        .shadow(color: Color(red: status.shadow.color.r, green: status.shadow.color.g,
                             blue: status.shadow.color.b, opacity: status.shadow.color.o),
                radius: status.shadow.radius,
                x: status.shadow.x,
                y: status.shadow.y)
        .overlay(
            // 図の描画
            Shape(status: $status)
                .frame(width: status.size.width, height: status.size.height)
                .foregroundColor(Color(red: status.color.r, green: status.color.g,
                                       blue: status.color.b, opacity: status.color.o))
                .opacity(status.opacity)
        )
        .rotationEffect(Angle(degrees: status.rotation))
        
        .position(status.position)
        .gesture(DragGesture()
            .onChanged({ value in
                if !status.lock { self.status.position = value.location }})
        )
        
    }
}

struct MiniShapeView: View {
    @Binding var status: ShapeConfiguration
    @State var reduction: CGFloat
    var body: some View {
        // 縁の描画
        Shape(status: $status)
            .foregroundColor(Color(red: status.frame.color.r, green: status.frame.color.g,
                                   blue: status.frame.color.b, opacity: status.frame.color.o))
        .frame(width: (status.size.width + status.frame.width*2)/reduction,
               height: (status.size.height + status.frame.width*2)/reduction)
        .opacity(status.frame.opacity)
        .shadow(color: Color(red: status.shadow.color.r, green: status.shadow.color.g,
                             blue: status.shadow.color.b, opacity: status.shadow.color.o),
                radius: status.shadow.radius/reduction,
                x: status.shadow.x/reduction,
                y: status.shadow.y/reduction)
        .overlay(
            // 図の描画
            Shape(status: $status)
                .frame(width: status.size.width/reduction,
                       height: status.size.height/reduction)
                .foregroundColor(Color(red: status.color.r, green: status.color.g,
                                       blue: status.color.b, opacity: status.color.o))
                .opacity(status.opacity)
        )
        .rotationEffect(Angle(degrees: status.rotation))
        
        .position(x: status.position.x/reduction,
                  y: status.position.y/reduction)
        .gesture(DragGesture()
            .onChanged({ value in
                if !status.lock { self.status.position = value.location }})
        )
        
    }
}

struct Shape: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        if status.style == "Rectangle" {
            RectangleView(status: $status)
        } else if status.style == "Circle" {
            CircleView(status: $status)
        } else if status.style == "Ellipse" {
            ElipseView(status: $status)
        } else if status.style == "Text" {
            TextView(status: $status)
        } else if status.style == "SFSymbols" {
            SymbolView(status: $status)
        }
    }
}

struct RectangleView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        RoundedRectangle(cornerRadius: status.corner)
    }
}

struct CircleView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        Capsule()
    }
}

struct ElipseView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        Ellipse()
    }
}

struct TextView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        Text(status.text.character == "" ?
             "テキスト" : "\(status.text.character)")
        .font(.custom(status.text.font, size: status.text.size))
    }
}

struct SymbolView: View {
    @Binding var status: ShapeConfiguration
    var body: some View {
        Image(systemName: status.symbolName)
            .resizable()
    }
}

// 図の構造 構成=configuration
struct ShapeConfiguration: Identifiable, Codable {
    var id = UUID().uuidString
    var style: String
    var color: SColor
    var size: CGSize
    var position: CGPoint
    var opacity: Double
    var rotation: Double
    var shadow: ShadowConfiguration
    var frame: FrameConfiguration
    
    var lock: Bool
    var corner: CGFloat
    var symbolName: String
    var text: TextConfiguration
}

// カラー(Codable準拠のために用意)
struct SColor: Identifiable, Codable {
    var id = UUID().uuidString
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
    var o: CGFloat
}

// シャドウ
struct ShadowConfiguration: Codable {
    var color: SColor
    var radius: CGFloat
    var x: CGFloat
    var y: CGFloat
}

// フチ
struct FrameConfiguration: Codable {
    var width: CGFloat
    var color: SColor
    var opacity: CGFloat
}


// 文字
struct TextConfiguration: Codable {
    var character: String
    var font: String
    var size: CGFloat
}

struct test: Identifiable, Codable {
    var id = UUID().uuidString
    var size: Double
    var a: CGFloat
    var b: CGSize
    var c: CGPoint
//    var d: Color
}

