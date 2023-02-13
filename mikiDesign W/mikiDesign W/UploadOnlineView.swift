//
//  UploadOnlineView.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2023/02/11.
//

import SwiftUI

struct UploadOnlineView: View {
    @State var layout: [ShapeConfiguration]
    @Environment(\.dismiss) var dismiss
    @ObservedObject var FManager = FireBaseManager()
    @State var createdLayoutName = ""
    @State var selectedCategoly = "ネタ"
    @State var isLayoutCancopy = true
    @State var uploadArelt = false
    let tag: [tags] =
    [tags(id: "hobby", tag: "ネタ", icon: "😆"),tags(id: "game", tag: "ゲーム", icon: "🥳"),
     tags(id: "shanty", tag: "オシャレ", icon: "🥸"),tags(id: "idea", tag: "アイデア", icon: "🤔")]
    var body: some View {
        VStack(spacing: 10) {
            //            MiniLayouts(layout: layout, reduction: 1.5)
            ZStack {
//                Rectangle().frame(width: phone.w/2, height: phone.h/2)
//                    .frame(width: phone.w/2, height: phone.h/3)
//                    .clipped()
                MiniLayouts(layout: layout, reduction: 2)
                    .frame(width: phone.w/2, height: phone.h/3)
                    .clipped()
                Image("clear")
                    .resizable()
                    .frame(width: phone.w/2, height: phone.h/3)
                if createdLayoutName.count >= 6 && createdLayoutName.count <= 18 {
                    Button(action: {
                        uploadArelt = true
                        FManager.layout = Layouts(id: UUID().uuidString, name: createdLayoutName, category: selectedCategoly, canCopy: isLayoutCancopy, layout: layout)
                        FManager.uploadLayoutData()
                    }, label: {
                        Text("アップロード")
                            .font(.custom("", size: 25))
                        
                    })
                }
            }
            
            //  名前
            Text("レイアウトネーム").font(.custom("", size: 10))
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style: StrokeStyle(lineWidth: 3, dash: [7]))
                    .frame(width: phone.w*0.9, height: phone.h*0.05)
                    .foregroundColor(createdLayoutName.count >= 6 && createdLayoutName.count <= 18 ? Color.mint : Color.red)
                TextField("名前を入力してください。(6~18文字)", text: $createdLayoutName)
                    .frame(width: phone.w*0.85)
            }
            Spacer().frame(height: 10)
            //  カテゴリ
            Text("カテゴリを選択してください。").font(.custom("", size: 10))
            HStack {
                ForEach(tag){ status in
                    TagSelectButton(select: $selectedCategoly, data: status)
                }
            }
            Spacer().frame(height: 10)
            //  コピー可否
            Text("公開設定").font(.custom("", size: 10))
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style: StrokeStyle(lineWidth: 3, dash: [7]))
                    .frame(width: phone.w*0.9, height: phone.h*0.15)
                    .foregroundColor(Color.brown)
                VStack {
                    Text("あなたの作品を他のユーザーが")
                        .frame(width: phone.w*0.8, alignment: .leading)
                    
                    HStack(spacing: 0) {
                        Text("コピーすることを許しま")
                        if isLayoutCancopy {
                            Text("す").foregroundColor(Color.cyan)
                                .font(.title2)
                        } else {
                            Text("せん").foregroundColor(Color.red)
                                .font(.title2)
                        }
                        Toggle("", isOn: $isLayoutCancopy).frame(width: 60)
                    }
                }
            }
            //  やめとく
            ZStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("やめとく").font(.custom("", size: 20))
                })
            }.padding(.top, 10)
            .alert("アップロードしました", isPresented: $uploadArelt){
                Button("OK"){
                    dismiss()
                }
            } message: {
                Text("引き続き創作活動を\nお楽しみください。")
            }
        }
    }
}
