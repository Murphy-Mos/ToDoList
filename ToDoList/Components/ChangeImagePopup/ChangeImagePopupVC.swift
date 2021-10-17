//
//  ChangeImagePopupVC.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import UIKit

final class ChangeImagePopupVC: UIViewController {
    
    var delegate: ChangeImagePopupDelegate?
    var imageInteractionService: ImageInteractionService?
    
    //MARK: - IBActions
    
    @IBAction private func changeImageDidTap(_ sender: Any) {
        showImagePicker()
    }
    
    @IBAction func removeImageDidTap(_ sender: Any) {
        delegate?.removeImage()
        dismiss(animated: true)
    }
    
    @IBAction private func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func showImagePicker() {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker,
                animated: true,
                completion: nil)
    }
}


//MARK: - UIImagePickerControllerDelegate
extension ChangeImagePopupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            guard (try? FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false) as NSURL) != nil else { return }
            
            let uniqueIdentifier = UUID()
            imageInteractionService?.saveImage(imageName: uniqueIdentifier.uuidString, image: pickedImage)
            delegate?.imageWasChanged(imageName: uniqueIdentifier.uuidString)
            
        } else {
            delegate?.imageLoadError()
        }
        
        picker.dismiss(animated: true)
        dismiss(animated: true)
    }
}


//MARK: - Assembly
extension ChangeImagePopupVC {
    
    static func assemble(delegate: ChangeImagePopupDelegate, imageInteractionService: ImageInteractionService?) -> UIViewController {
        
        guard let view = UIStoryboard(name: "ChangeImagePopupVC", bundle: nil).instantiateViewController(withIdentifier: "ChangeImagePopupVC") as? ChangeImagePopupVC else { return UIViewController() }
        
        view.delegate = delegate
        view.imageInteractionService = imageInteractionService
        
        return view
    }
}
