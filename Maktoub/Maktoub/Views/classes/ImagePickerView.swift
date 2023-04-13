//
//  ImagePickerView.swift
//  Maktoub
//
//  Created by user236595 on 4/4/23.
//

import Foundation
import SwiftUI
struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    var completion: ((Result<UIImage, Error>) -> Void)?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                parent.completion?(.failure(NSError(domain: "ImagePickerView", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error picking image"])))
                return
            }
            
            parent.selectedImage = selectedImage
            parent.completion?(.success(selectedImage))
            
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.completion?(.failure(NSError(domain: "ImagePickerView", code: 2, userInfo: [NSLocalizedDescriptionKey: "User cancelled"])))
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
