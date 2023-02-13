//
//  LayoutView.swift
//  WatanabeDesign
//
//  Created by 渡辺幹 on 2022/07/28.
//

import SwiftUI

struct LayoutView: View {
    @StateObject private var model = LayoutModel()
    @State var isEditMode = false
    @State var ControlerPosition = CGPoint(x: 0, y: 0)
    @State var summonedTabPosition = CGPoint(x: 0, y: 0)
    var body: some View {
        ZStack {
            Text("")
                .alert(isPresented: $model.areltFlag.save) {
                    Alert(
                        title: Text("進行状況を保存します。"),
                        message: Text("*保存した場合巻き戻ることができません。"),
                        primaryButton: .default(Text("保存する"),
                                                action: {model.saveLayout()}),
                        secondaryButton: .destructive(Text("保存しない"),
                                            action: { print("「いいえ」が押されました") })
                    )
                }
            Text("")
                .alert(isPresented: $model.areltFlag.home) {
                    Alert(
                        title: Text("ホームへ戻ります。"),
                        message: Text("進行状況を保存しますか？"),
                        primaryButton: .default(Text("保存して終了"),
                                                action: {
                                                    model.saveLayout()
                                                    model.dispManager.display = "Home"
                                                }),
                        secondaryButton: .destructive(Text("保存せず終了"),
                                            action: {
                                                model.dispManager.display = "Home"
                                            })
                    )
                }
            Text("")
                .alert(isPresented: $model.areltFlag.delete) {
                    Alert(
                        title: Text("選択されている図形を\n削除します。"),
                        message: Text("削除しますか？"),
                        primaryButton: .default(Text("する"),
                                                action: {model.removeShape()}),
                        secondaryButton: .destructive(Text("しない"),
                                            action: { print("「いいえ」が押されました") })
                    )
                }
            // 図の全表示
            ForEach($model.shapeArray){ status in
                ShapeView(status: status)
                    .onTapGesture {
                        model.select = model.searchArray(id: status.id) ?? 0
                    }
            }
            
            // 選択表示
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(width: model.selectedShape().size.width + 10,
                       height: model.selectedShape().size.height + 10)
                .foregroundColor(Color.red)
                .overlay(
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color.white)
                        .opacity(model.selectedShape().lock ?
                                 1.0 : 0.0)
                        .frame(alignment: .bottomTrailing)
                        .shadow(color: Color.black, radius: 10, x: 0, y: 0)
                )
                .rotationEffect(Angle(degrees: model.selectedShape().rotation))
                .position(model.selectedShape().position)
            
            // コントローラ
            ControllerView(model: model)
                .position(ControlerPosition)
                .animation(.default, value: model.isHide)
            // コントローラの影
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 10)
                .frame(width: phone.w*0.5 + 5,
                       height: model.isHide ? 35 : phone.w*0.8 + 5)
                .animation(.default, value: model.isHide)
                .foregroundColor(Color.black)
                .opacity(0.05)
                .position(ControlerPosition)
                .gesture(DragGesture()
                    .onChanged({ value in
                        self.ControlerPosition = CGPoint(
                            x: value.location.x,
                            y: value.location.y
                        ) }))
                .onAppear(){
                    ControlerPosition.x = phone.w*0.75
                    ControlerPosition.y = phone.w*0.4
                }
            
            SummonedEditTab(model: model, status: $model.shapeArray[model.select])
                .position(summonedTabPosition)
                .gesture(DragGesture()
                    .onChanged({ value in
                        self.summonedTabPosition = value.location}))
                .onAppear(){
                    summonedTabPosition.x = phone.w/2
                    summonedTabPosition.y = phone.w*0.2
                }
        }
        .sheet(isPresented: $model.shouwingUploads, content: {
            UploadOnlineView(layout: model.shapeArray)
        })
        .onAppear() {
            model.assignmentLayout()
        }
//        .alert("タイトル", isPresented: $showingAlert){
//            Button("ボタン1"){
//                // ボタン1が押された時の処理
//            }
//            Button("ボタン2"){
//                // ボタン2が押された時の処理
//            }
//        } message: {
//            Text("詳細メッセージ")
//        }
    }
}

struct LayoutView_Previews: PreviewProvider {
    static var previews: some View {
        LayoutView()
    }
}
