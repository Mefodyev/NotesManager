//
//  AddNewTaskToWorkViewController.swift
//  Notes Manager
//
//  Created by Alexey Mefodyev on 29.01.2020.
//  Copyright © 2020 LexMefodyev. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewTaskToWorkViewController: UIViewController {
    
    var imageIsSelectedByUser = false
    var currentTask: WorkTask?
    let notifications = Notifications()
    
    
    @IBOutlet weak var workTaskImage: UIImageView!
    @IBOutlet weak var chooseAnImageButton: UIButton!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskLocationTextField: UITextField!
    @IBOutlet weak var showLocationButton: UIButton!
    
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    
    
    @IBOutlet weak var linkedToTimeLabel: UILabel!
    @IBOutlet weak var linkedToTimeSwitcher: UISwitch!
    
    @IBOutlet weak var oneHourNotificationSwither: UISwitch!
    @IBOutlet weak var twoHoursNotificationSwitcher: UISwitch!
    @IBOutlet weak var oneDayNotificationSwitcher: UISwitch!
    
    @IBOutlet weak var remindersView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var reminderStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var addToDatabaseButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseAnImageButton.titleLabel?.lineBreakMode = .byWordWrapping
        remindersView.alpha = 0
        setupLocationButton()
        addToDatabaseButton.isEnabled = false
        taskNameTextField.addTarget(self, action: #selector(tfChanged), for: .editingChanged)
        setupEditScreen()
        
        
        
    }
    
    
    @IBAction func timeLinkedSwitcherTapped(_ sender: UISwitch) {
        
        if linkedToTimeSwitcher.isOn == false {
            UIView.animate(withDuration: 0.3) {
                self.remindersView.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.remindersView.alpha = 1
            }
        }
    }
    
    
    
    @IBAction func chooseAnImageButtonIsTouchedDown(_ sender: Any) {
        showImageChooserActionSheet()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "showMap" {
            return
        }
        
        let mapVC = segue.destination as! MapViewController
        mapVC.workTask = currentTask
    }
    
    
    func saveWorkTask() {
        
        let image = imageIsSelectedByUser ? workTaskImage.image : #imageLiteral(resourceName: "pencil")
        let imageData = image?.pngData()
        
        
        let newWorkTask = WorkTask(name: taskNameTextField.text ?? "", taskDescription: taskDescriptionTextView.text, taskDate: datePicker.date, imageData: imageData, taskLocation: taskLocationTextField.text ?? "", oneHourReminder: false, twoHoursReminder: false, oneDayReminder: false)
        
        if oneHourNotificationSwither.isOn {
            newWorkTask.oneHourReminder = true
        }
        if twoHoursNotificationSwitcher.isOn {
            newWorkTask.twoHoursReminder = true
        }
        if oneDayNotificationSwitcher.isOn {
            newWorkTask.oneDayReminder = true
        }
        
        //если мы редактируем уже сохраненную запись
        if currentTask != nil {
            
            
            
            try! realm.write {
                currentTask?.name = newWorkTask.name
                currentTask?.taskDescription = newWorkTask.taskDescription
                currentTask?.taskDate = newWorkTask.taskDate
                currentTask?.imageData = newWorkTask.imageData
                currentTask?.taskLocation = newWorkTask.taskLocation
                currentTask?.oneHourReminder = newWorkTask.oneHourReminder
                currentTask?.twoHoursReminder = newWorkTask.twoHoursReminder
                currentTask?.oneDayReminder = newWorkTask.oneDayReminder
                
                if newWorkTask.oneHourReminder == true {
                    notifications.scheduleHourNotification(notificationType: "Один час", time0fTask: (newWorkTask.taskDate! as Date))
                    print("Schedule not-n was set for \(String(describing: newWorkTask.taskDate))")
                }
            }
        } else {

            //если мы сохраняем новую запись
            StorageManager.saveWorkObject(newWorkTask)
            if newWorkTask.oneHourReminder == true {
                notifications.scheduleHourNotification(notificationType: "Один час", time0fTask: newWorkTask.taskDate! as Date)
                
                print("WorkTask saved via StorageManager saving function")
                print("Schedule not-n was set for \(String(describing: newWorkTask.taskDate))")
                
            }
        }
    }
    
    
    
    private func setupLocationButton() {
        
        
        if currentTask?.taskLocation == nil {
            showLocationButton.alpha = 0
        } else {
            showLocationButton.titleLabel?.sizeToFit()
            showLocationButton.titleLabel?.textColor = .white
            showLocationButton.backgroundColor = .blue
            showLocationButton.layer.cornerRadius = showLocationButton.frame.size.height/7
            showLocationButton.clipsToBounds = true
        }
    }
    
    //метод, позволяющий передать в редактируемую ячейку данные, введенные в конкретную задачу ранее
    private func setupEditScreen() {
        if currentTask != nil {
            setupNavigationBar()
            imageIsSelectedByUser = true
            linkedToTimeSwitcher.isOn = true
            remindersView.alpha = 1
            imageIsSelectedByUser = true
            guard let data = currentTask?.imageData, let image = UIImage(data: data) else { return }
            
            workTaskImage.image = image
            chooseAnImageButton.backgroundColor = .clear
            chooseAnImageButton.setTitleColor(.clear, for: .normal)
            workTaskImage.contentMode = .scaleAspectFill
            taskNameTextField.text = currentTask?.name
            taskDescriptionTextView.text = currentTask?.taskDescription
            taskLocationTextField.text = currentTask?.taskLocation ?? ""
            guard let taskDate = currentTask?.taskDate else { return }
            datePicker.date = taskDate
            if currentTask?.oneHourReminder == true {
                oneHourNotificationSwither.isOn = true
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.title = currentTask?.name
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}


extension AddNewTaskToWorkViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
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
        imageIsSelectedByUser = true
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func tfChanged() {
        
        if taskNameTextField.text?.isEmpty == true {
            addToDatabaseButton.isEnabled = false
        } else {
            addToDatabaseButton.isEnabled = true
        }
    }
    
    //скрываем клавиатуру по нажатию на дан
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
