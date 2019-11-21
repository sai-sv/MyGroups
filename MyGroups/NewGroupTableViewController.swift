//
//  NewGroupTableViewController.swift
//  MyGroups
//
//  Created by Admin on 18.11.2019.
//  Copyright © 2019 Sergei Sai. All rights reserved.
//

import UIKit

class NewGroupTableViewController: UITableViewController {

    var currentGroup: Group?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var groupLocation: UITextField!
    @IBOutlet weak var groupGenre: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView() // скрываем пустые разлинованные строки таблицы
        saveButton.isEnabled = false
        groupName.addTarget(self, action: #selector(groupNameChanged), for: .editingChanged)
        
        setupEditScreen()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera") // начни набирать image literal, по двойному клику выбрать нужно изображение
            let photoIcon = #imageLiteral(resourceName: "photo")
                        
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(.camera)
            }
            cameraAction.setValue(cameraIcon, forKey: "image")
            cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photoAction = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(.photoLibrary)
            }
            photoAction.setValue(photoIcon, forKey: "image")
            photoAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(cameraAction)
            actionSheet.addAction(photoAction)
            actionSheet.addAction(cancelAction)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true) // скрываем клавиатуру по тапу вне поля ввода
        }
    }
    
    // navigation bar Cancel item action
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func saveGroup() {
        
        guard let imageData = groupImage.image?.pngData() else { return }
        let newGroup = Group(name: groupName.text!, location: groupLocation.text, genre: groupGenre.text, imageData: imageData, rating: Double(ratingControl.rating))
        
        if currentGroup != nil { // обновление существующего объекта (редактирование)
            try! realm.write {
                currentGroup?.name = newGroup.name
                currentGroup?.location = newGroup.location
                currentGroup?.genre = newGroup.genre
                currentGroup?.imageData = newGroup.imageData
                currentGroup?.rating = newGroup.rating
            }
        } else { // добавление нового объекта в БД
            StorageManager.saveObject(newGroup)
        }
    }
    
    private func setupEditScreen() {
        
        if let group = currentGroup {
            
            setupNavigationBar()
            
            guard let data = group.imageData, let image = UIImage(data: data) else { return }
            groupImage.image = image
            groupImage.contentMode = .scaleAspectFill
            groupName.text = group.name
            groupLocation.text = group.location
            groupGenre.text = group.genre
            ratingControl.rating = Int(group.rating)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = nil // убрать кнопку Cancel
        saveButton.isEnabled = true
        
        // скрываем надпись с кнопки Назад
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        title = currentGroup?.name // заголовок на NavigationBar
    }
}

// MARK: - TextField delegate
extension NewGroupTableViewController: UITextFieldDelegate {
    
    // скрываем клавиатуру по нажатию на Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func groupNameChanged() {
        saveButton.isEnabled = groupName.text?.isEmpty == false
    }
}

// MARK: - Image delegate
extension NewGroupTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(_ source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
        
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = source
            picker.allowsEditing = true // разрешаем пользователю редактирование изображения
            
            present(picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        groupImage.image = info[.editedImage] as? UIImage // забираем, отредактированное пользователем изображение
        groupImage.contentMode = .scaleAspectFill
        groupImage.clipsToBounds = true
        
        dismiss(animated: true) // скрываем окно
    }
}
