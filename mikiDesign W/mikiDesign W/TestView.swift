//
//  TestView.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/11.
//

import SwiftUI

struct TestView: View {
    @State var showingAlert = false
    @State var inputPass = ""
    var body: some View {
        ZStack {
            VStack {
                
                Button("Tap me!!") {
                    self.showingAlert = true
                }
                .alert("レイアウトの削除🤔", isPresented: $showingAlert, actions: {
                    TextField("'パスコード'を入力", text: $inputPass)
                    Button("オーケー", action: {
                        if inputPass == "" {  }
                    })
                    Button("キャンセル", role: .cancel, action: {})
                }, message: {
                    // Any view other than Text would be ignored
                    Text("展示版ではレイアウトの削除に\nパスコードが必要です。")
                })
                
               
                
            }
        }
        
    }
    func aaa() {
        print("deth")
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
