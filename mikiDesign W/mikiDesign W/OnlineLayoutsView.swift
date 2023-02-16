//
//  OnlineLayoutsView.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2023/01/31.
//

import SwiftUI

struct OnlineLayoutsView: View {
    @ObservedObject var dispManager: DispManager = .dispManager
    @ObservedObject var fireManager: FireBaseManager = .firebaseManager
    @AppStorage("mD_isGrid") var dispIsGrid = true
    @State var selectedTag = "ネタ"
    @State var nowShowLayout: Layouts = sampleLayouts.sample_1
    @State var dispBigLayout = false
    @State var dispLayoutInfo = false
    @State var showArelt = false
    @StateObject private var model = LayoutModel()
    private let colum = [GridItem(.adaptive(minimum: UIScreen.main.bounds.width/2.1), alignment: .top)]
    let tag: [tags] =
    [tags(id: "hobby", tag: "ネタ", icon: "😆"),tags(id: "game", tag: "ゲーム", icon: "🥳"),
     tags(id: "shanty", tag: "オシャレ", icon: "🥸"),tags(id: "idea", tag: "アイデア", icon: "🤔")]
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        dispManager.display = "Home"
                        print(fireManager.fireLayouts)
                    }, label: {
                        VStack {
                            Image(systemName: "return")
                                .resizable()
                                .frame(width: phone.w*0.1, height: phone.w*0.1)
                                .foregroundColor(Color.gray)
                            Text("戻る")
                                .font(.custom("", size: 10))
                                .foregroundColor(Color.black)
                        }
                    })
                    ForEach(tag){ status in
                        TagSelectButton(select: $selectedTag, data: status)
                    }
                }
                
                VStack {
                    // Grid表示/パノラマ表示
                    if dispIsGrid {
                        ScrollView(.vertical) {
                            Spacer().frame(height: 50)
                            LazyVGrid(columns: colum, spacing: 3) {
                                ForEach(fireManager.fireLayouts) { layout in
                                    if layout.category == selectedTag {
                                        Button(action: {
                                            nowShowLayout = layout
                                            dispBigLayout = true
                                        }){
                                            MiniLayouts(layout: layout.layout, reduction: 2.3)
                                                .clipped()
                                                .padding(5)
                                                .overlay(
                                                    Image("clear")
                                                        .frame(width: phone.w/2.5, height: phone.h/3)
                                                        .foregroundColor(Color.clear)
                                                )
                                        }
                                    }
                                }
                                Spacer().frame(height: 50)
                            }
                        }
                        .frame(width: phone.w)
                    } else {
                        ScrollView(.vertical) {
                                ForEach(fireManager.fireLayouts) { layout in
                                    if layout.category == selectedTag {
                                        Button(action: {
                                            nowShowLayout = layout
                                            dispBigLayout = true
                                        }){
                                            MiniLayouts(layout: layout.layout, reduction: 1.3)
                                                .clipped()
                                                .padding(5)
                                                .overlay(
                                                    Image("clear")
                                                        .frame(width: phone.w/1.3, height: phone.h/1.3)
                                                        .foregroundColor(Color.clear)
                                                )
                                        }
                                    }
                                }
                        }
                        .frame(width: phone.w)
                    }
                }.frame(width: phone.w, height: phone.h*0.8)
                    .border(Color.black)
                
            }
            Button(action: {
                dispIsGrid.toggle()
            }, label: {
                Circle()
                    .frame(width: phone.w*0.2)
                    .foregroundColor(Color.white)
                    .shadow(color: Color.gray, radius: 10)
                    .overlay(content: {
                        Image(systemName: dispIsGrid ? "light.panel" : "square.grid.2x2")
                            .resizable()
                            .frame(width: phone.w*0.1, height: phone.w*0.1)
                            .foregroundColor(Color.gray)
                    })
            })
            .position(x: phone.w*0.85, y: phone.h*0.85)
            
            if dispBigLayout {
                Rectangle()
                    .edgesIgnoringSafeArea(.vertical)
                    .foregroundColor(Color.white)
                Button(action: {
                    dispLayoutInfo.toggle()
                }, label: {
                    LayoutMiniMap(layout: $nowShowLayout.layout, model: model, reduction: 1.1)
                        .clipped()
                        .overlay(
                            Image("clear")
                                .frame(width: phone.w/1.1, height: phone.h/1.1)
                                .foregroundColor(Color.clear)
                        )
                })
                VStack {
                    if dispLayoutInfo {
                        Button(action: {
                            dispBigLayout.toggle()
                        }, label: {
                            Image(systemName: "x.square")
                                .resizable()
                                .frame(width: phone.w*0.1, height: phone.w*0.1)
                        })
                        .frame(width: phone.w/1.1, alignment: .topTrailing)
                        Spacer()
                        HStack {
                            Spacer().frame(width: phone.w*0.1)
                            Text("\(nowShowLayout.name)")
                                .font(.custom("Hiragino Mincho ProN", size: 20))
                                .frame(width: phone.w*0.7)
                                
                            Button(action: {
                                if nowShowLayout.canCopy {
                                    showArelt.toggle()
                                }
                            }, label: {
                                Image(systemName: "square.and.arrow.down")
                                    .resizable()
                                    .frame(width: phone.w*0.1, height: phone.w*0.12)
                                    .foregroundColor(Color.black)
                                    .overlay(
                                        Image(systemName: nowShowLayout.canCopy ? "o.circle.fill" : "xmark.shield.fill")
                                            .frame(width: phone.w*0.1, height: phone.w*0.1, alignment: .topTrailing)
                                            .foregroundColor(nowShowLayout.canCopy ? Color.cyan : Color.red)
                                    )
                            })
                            .alert(isPresented: $showArelt) {
                                Alert(
                                    title: Text("'\(nowShowLayout.name)'"),
                                    message: Text("を端末へ保存しますか？"),
                                    primaryButton: .default(Text("する"),
                                                            action: {selectSave_yes()}),
                                    secondaryButton: .destructive(Text("しない"),
                                                        action: { print("「いいえ」が押されました") })
                                )
                            }
                        }
                        .frame(width: phone.w, height: phone.w*0.15)
                        .background(Color.gray.opacity(0.5))
                    }
                }
                .frame(width: phone.w, height: phone.h/1.1)
            }
            
        }
    }
    func selectSave_yes() {
        let nowData: Layouts = nowShowLayout
        print(nowData.name)
        model.saveOnlineLayout(data: nowData)
    }
}

struct TagSelectButton: View {
    @Binding var select: String
    let data: tags
    var body: some View {
        Button(action: {
            select = data.tag
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: phone.w*0.17, height: phone.w*0.2)
                    .foregroundColor(Color.white)
                    .shadow(color: Color.gray, radius: 10)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: StrokeStyle(lineWidth: 3, dash: [
                        select == data.tag ? 7 : 0]))
                    .frame(width: phone.w*0.17-1, height: phone.w*0.2-1)
                    .foregroundColor(Color.cyan)
                VStack {
                    Text(data.icon)
                        .font(.custom("", size: 50))
                    Text(data.tag)
                        .font(.custom("", size: 10))
                        .foregroundColor(Color.black)
                }
            }
        })
    }
}

struct tags: Identifiable {
    var id: String
    var tag: String
    var icon: String
}

class sampleLayouts {
    static let sample_1: Layouts = Layouts(id: "sample1 for created W.M",
                                           name: "テスト用サンプル1",
                                           category: "ネタ",
                                           canCopy: false,
                                           layout: [ShapeConfiguration(style: "Text", color: SColor(r: 1.0, g: 1.0, b: 1.0, o: 1.0), size: CGSize(width: 400, height: 100), position: CGPoint(x: 150, y: 300), opacity: 1.0, rotation: 0.0, shadow: ShadowConfiguration(color: SColor(r: 1.0, g: 1.0, b: 1.0, o: 1.0), radius: 10, x: 3, y: 3), frame: FrameConfiguration(width: 0, color: SColor(r: 1.0, g: 1.0, b: 1.0, o: 0.0), opacity: 0.0), lock: false, corner: 0, symbolName: "", text: TextConfiguration(character: "サンプル_ネタ1", font: "", size: 20))])
    static let sample_2: Layouts = Layouts(id: "sample2 for created W.M",
                                           name: "テスト用サンプル2",
                                           category: "ネタ",
                                           canCopy: false,
                                           layout: [ShapeConfiguration(style: "Text", color: SColor(r: 1.0, g: 1.0, b: 1.0, o: 1.0), size: CGSize(width: 400, height: 100), position: CGPoint(x: 150, y: 300), opacity: 1.0, rotation: 0.0, shadow: ShadowConfiguration(color: SColor(r: 1.0, g: 1.0, b: 1.0, o: 1.0), radius: 10, x: 3, y: 3), frame: FrameConfiguration(width: 0, color: SColor(r: 1.0, g: 1.0, b: 1.0, o: 0.0), opacity: 0.0), lock: false, corner: 0, symbolName: "", text: TextConfiguration(character: "サンプル_ネタ2", font: "", size: 20))])
    static let sample_3: Layouts = Layouts(id: "sample3 for created W.M",
                                           name: "テスト用サンプル3",
                                           category: "ゲーム",
                                           canCopy: false,
                                           layout: [ShapeConfiguration(style: "Rectangle", color: SColor(r: 0.5, g: 0.3, b: 1.0, o: 1.0), size: CGSize(width: 400, height: 100), position: CGPoint(x: 150, y: 300), opacity: 1.0, rotation: 0.0, shadow: ShadowConfiguration(color: SColor(r: 1.0, g: 1.0, b: 1.0, o: 1.0), radius: 10, x: 3, y: 3), frame: FrameConfiguration(width: 0, color: SColor(r: 1.0, g: 1.0, b: 1.0, o: 0.0), opacity: 0.0), lock: false, corner: 0, symbolName: "", text: TextConfiguration(character: "サンプル_ゲーム", font: "", size: 20))])
    
}

struct OnlineLayoutsView_Previews: PreviewProvider {
    static var previews: some View {
        OnlineLayoutsView()
    }
}
