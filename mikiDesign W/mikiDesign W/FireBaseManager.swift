//
//  FireBaseManager.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2023/01/31.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

enum FCollectionReference: String {
    case Layouts
}


func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    print("----------FirebaseReference")
    return Firestore.firestore().collection(collectionReference.rawValue)
}


class FireBaseManager: ObservableObject {
    static let firebaseManager = FireBaseManager()
    @Published var layout: Layouts!
    @Published var fireLayouts: [Layouts] = []
    
    // Firebaseからデータの取得。
    func getLayoutData() {
        fireLayouts = []
        let db = Firestore.firestore()
        let ref = db.collection("Layouts")
            ref.getDocuments { querySnapShot, error in
                if error != nil {
                    print("Error starting game")
                }

                if let layoutData = querySnapShot {
                    for layout in layoutData.documents {
                        let new = try? layout.data(as: Layouts.self)
                        self.fireLayouts.append(new!)
                        print("\(self.fireLayouts) it is Laypout on Firebase")
                    }
                } else {
                    print("nilllll")
                }
            }
    }
    
    // Firebaseにレイアウトを追加。
    func uploadLayoutData() {
        do {
            try FirebaseReference(.Layouts)
                .document(self.layout.id)
                .setData(from: self.layout)
        } catch {
            print("Error creating online game", error.localizedDescription)
        }
    }
}
