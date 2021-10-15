//
//  ChangeImagePopupVC.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 14.10.2021.
//

import UIKit

final class ChangeImagePopupVC: UIViewController {
    
    var delegate: ChangeImagePopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: - IBActions
    
    @IBAction private func changeImageDidTap(_ sender: Any) {
        showImageAlert()
    }
    
    @IBAction func removeImageDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction private func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func showImageAlert() {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        
        let alert = UIAlertController(title: "Добавить фото 👇",
                                      message: "Выбери источник",
                                      preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Фото",
                                         style: .default) { action in
            picker.sourceType = .camera
            self.present(picker,
                         animated: true)
        }
        
        let lybraryAction = UIAlertAction(title: "Галерея",
                                         style: .default) { action in
            picker.sourceType = .photoLibrary
            self.present(picker,
                         animated: true)
        }
        
        alert.addAction(cameraAction)
        alert.addAction(lybraryAction)
        
        present(alert,
                animated: true,
                completion: nil)
    }
}


//MARK: - UIImagePickerControllerDelegate
extension ChangeImagePopupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            if let imageData = pickedImage.pngData() {
                guard let directory = try? FileManager.default.url(for: .documentDirectory,
                                                                   in: .userDomainMask,
                                                                   appropriateFor: nil,
                                                                   create: false) as NSURL else { return }
                do {
                    let newUrl = ImageUserDefaults.shared.generateNewURLPath()
                    try imageData.write(to: directory.appendingPathComponent(newUrl)!)
                    let url = directory.appendingPathComponent(newUrl)!
                    delegate?.imageWasChanged(path: url.absoluteString, image: pickedImage)
                } catch {
                    print("Ошибка при попытке записи (\(error))")
                }
            }
        } else {
            print("Не удалось получить фото")
        }
        
        picker.dismiss(animated: true)
        dismiss(animated: true)
    }
}


//MARK: - Assembly
extension ChangeImagePopupVC {
    
    static func assemble(delegate: ChangeImagePopupDelegate) -> UIViewController {
        
        guard let view = UIStoryboard(name: "ChangeImagePopupVC", bundle: nil).instantiateViewController(withIdentifier: "ChangeImagePopupVC") as? ChangeImagePopupVC else { return UIViewController() }
        
        view.delegate = delegate
        
        return view
    }
}
