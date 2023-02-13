//
//  HomeView.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/10.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var dispManager: DispManager = .dispManager
    @ObservedObject var fireManager: FireBaseManager = .firebaseManager
    @StateObject private var model = LayoutModel()
    @State var areltFlag: (edit: Bool,add: Bool,remove:Bool,online:Bool) =
    (edit: false,add: false,remove:false,online:false)
    @State var inputPass = ""
    private let layout = [GridItem(.adaptive(minimum: UIScreen.main.bounds.width/2.5), alignment: .top)]
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.blue)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer().frame(height: phone.h*0.1)
                
                ScrollView {
                    Spacer().frame(height: 50)
                    LazyVGrid(columns: layout, spacing: 3) {
                        ForEach($dispManager.savedLayouts){ layout in
                            Button(action: {
                                dispManager.selectLayoutsId = layout.id
                            }){
                                LayoutMiniMap(layout: layout.layout, model: model, reduction: 3)
                                    .clipped()
                                    .padding(5)
                                    .border(dispManager.selectLayoutsId==layout.id ? Color.red : Color.clear,
                                            width: 5)
                                    .overlay(
                                        Image("clear")
                                            .frame(width: phone.w/2.5, height: phone.h/3)
                                            .foregroundColor(Color.clear)
                                    )
                                    
                            }
                        }
                        Button(action: {
                            let newId = UUID().uuidString
                            dispManager.selectLayoutsId = newId
                            dispManager.savedLayouts.append(Layouts(id: newId, name: "", category: "ネタ", canCopy: true, layout: []))
                            dispManager.display = "Layout"
                        }){
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 3)
                                .frame(width: phone.w/3, height: phone.h/3)
                                .padding(5)
                                .overlay(
                                    Text("＋")
                                        .font(.custom("default", size: 50))
                                )
                        }
                    }
                    Spacer().frame(height: 50)
                }
                .frame(width: phone.w, height: phone.h*0.7)
                .background(Color.white)
                
                // 画面下部の操作ボタン。編集 新規 削除
                HStack(spacing: phone.w/15) {
                    Button(action: {
                        areltFlag.edit.toggle()
                    }){
                        Image(systemName: "wand.and.stars")
                            .resizable()
                            .frame(width: phone.w/10, height: phone.w/10)
                            .foregroundColor(Color.white)
                    }
                    .alert(isPresented: $areltFlag.edit) {
                        Alert(
                            title: Text("編集を開始します✍️"),
                            message: Text(""),
                            primaryButton: .default(Text("する"),
                                                    action: {
                                                        dispManager.display = "Layout"
                                                    }),
                            secondaryButton: .destructive(Text("しない"),
                                                          action: { print("「いいえ」が押されました") })
                        )
                    }
                    Button(action: {
                        areltFlag.add.toggle()
                    }){
                        Image(systemName: "plus.square")
                            .resizable()
                            .frame(width: phone.w/10, height: phone.w/10)
                            .foregroundColor(Color.white)
                    }
                    .alert(isPresented: $areltFlag.add) {
                        Alert(
                            title: Text("新規作成"),
                            message: Text("新しくレイアウトを作成します😤"),
                            primaryButton: .default(Text("する"),
                                                    action: {
                                                        let newId = UUID().uuidString
                                                        dispManager.selectLayoutsId = newId
                                                        dispManager.savedLayouts.append(Layouts(id: newId, name: "", category: "ネタ", canCopy: true, layout: []))
                                                        dispManager.display = "Layout"
                                                    }),
                            secondaryButton: .destructive(Text("しない"),
                                                          action: { print("「いいえ」が押されました") })
                        )
                    }
                    Button(action: {
                        areltFlag.remove.toggle()
                    }){
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: phone.w/10, height: phone.w/10)
                            .foregroundColor(Color.white)
                    }
                    .alert("レイアウトの削除🤔", isPresented: $areltFlag.remove, actions: {
                        TextField("'パスコード'を入力", text: $inputPass)
                        Button("オーケー", action: {
                            if inputPass == "ひみつ" {
                                model.removeLayout(layoutId: dispManager.selectLayoutsId)
                            }
                        })
                        Button("キャンセル", action: {})
                    }, message: {
                        Text("展示版ではレイアウトの削除に\nパスコードが必要です。")
                    })
                    Button(action: {
                        areltFlag.online.toggle()
                    }){
                        Image(systemName: "network")
                            .resizable()
                            .frame(width: phone.w/10, height: phone.w/10)
                            .foregroundColor(Color.white)
                    }
                    .alert(isPresented: $areltFlag.online) {
                        Alert(
                            title: Text("オンラインアトリエ👁️"),
                            message: Text("ようこそオンラインアトリエへ。\nオンライン上の作品を閲覧しましょう"),
                            primaryButton: .default(Text("突入"),
                                                    action: {
                                                        fireManager.getLayoutData()
                                                        dispManager.display = "Online"}),
                            secondaryButton: .destructive(Text("辞退"),
                                                          action: { print("「いいえ」が押されました") })
                        )
                    }
                }.frame(height: phone.h*0.1)
                Spacer().frame(height: phone.h*0.1)
                
            }.frame(height: phone.h)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
