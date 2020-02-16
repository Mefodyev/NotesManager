//
//  AddNewTaskToWorkViewController.swift
//  Notes Manager
//
//  Created by Alexey Mefodyev on 29.01.2020.
//  Copyright © 2020 LexMefodyev. All rights reserved.
//

import UIKit

class AddNewTaskToWorkViewController: UIViewController {
   
    
    @IBOutlet weak var workTaskImage: UIImageView!
    @IBOutlet weak var chooseAnImageButton: UIButton!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskBeginDateTextField: UITextField!
    
    @IBOutlet weak var taskDeadlineDateTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseAnImageButton.titleLabel?.lineBreakMode = .byWordWrapping
//        guard let chooseAnImageButton = chooseAnImageButton else { return }
//        NSLayoutConstraint(item: chooseAnImageButton, attribute: .centerX, relatedBy: .equal, toItem: workTaskImage, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
    }
    
    @IBAction func chooseAnImageButtonIsTouchedDown(_ sender: Any) {
        showImageChooserActionSheet()
    }
    
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NewWorkItem", for: indexPath) as! NewWorkItemTableViewCell
//
//
//        return cell
//    }
//
//
//

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension AddNewTaskToWorkViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImageChooserActionSheet() {
        
        let actionSheet = UIAlertController(title: "Способ выбора изображения", message: "", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let fromLibrary = UIAlertAction(title: "Из фотоплёнки", style: .default) { action in
            print("choosing from library")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let makeAPicture = UIAlertAction(title: "Сделать фото", style: .default) { action in
            print("making a picture")
            let imagePicker = UIImagePickerController()
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
            }
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        actionSheet.addAction(cancel)
        actionSheet.addAction(fromLibrary)
        actionSheet.addAction(makeAPicture)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            workTaskImage.image = editedImage
            chooseAnImageButton.backgroundColor = .clear
            chooseAnImageButton.titleLabel?.textColor = .clear
        } else {
            if let originalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                workTaskImage.image = originalImage
                chooseAnImageButton.backgroundColor = .clear
                chooseAnImageButton.titleLabel?.textColor = .clear
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}
