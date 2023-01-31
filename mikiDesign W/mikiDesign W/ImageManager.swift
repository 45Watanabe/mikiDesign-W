//
//  ImageManager.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2023/01/17.
//

import SwiftUI

class ImageManager: ObservableObject {
    static let imageManager: ImageManager = ImageManager()
    init() {
        loadKeyList()
    }
    @Published var keyList: [String] = []
    let ud = UserDefaults.standard
    
    // keyを指定して画像をuserdefaultsの保存
    func saveImage(id: String, image: UIImage) {
        addKeyList(id: id)
        ud.setUIImageToData(image: image, forKey: id)
        print(keyList)
    }
    
    // keyListをuserdefaultsから取得
    func loadKeyList() {
        if let savedKey = ud.array(forKey: "mikiDesign_keyList") {
             keyList = savedKey as! [String]
        }
        printAllKey()
    }
    // keyListにkeyを追加、保存
    func addKeyList(id: String) {
        keyList.append(id)
        ud.set(keyList, forKey: "mikiDesign_keyList")
    }
    
    func remove(id: String) {
        keyList.removeAll(where: {$0 == id})
        ud.set(keyList, forKey: "mikiDesign_keyList")
        ud.removeImage(forKey: id)
    }
    
    func printAllKey() {
        for key in keyList {
            print(key)
        }
    }
}

extension UserDefaults {
    func setUIImageToData(image: UIImage, forKey: String) {
        let nsdata = image.pngData()
        self.set(nsdata, forKey: forKey)
    }

    func image(forKey: String) -> UIImage {
        let data = self.data(forKey: forKey)
        let returnImage = UIImage(data: data!)
        return returnImage!
    }
    
    func removeImage(forKey: String) {
        self.removeObject(forKey: forKey)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage?
    
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

