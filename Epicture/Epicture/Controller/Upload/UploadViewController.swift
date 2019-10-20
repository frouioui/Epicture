//
//  UploadViewController.swift
//  Epicture
//
//  Created by Cecile on 20/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    enum ImageType {
        case png
        case jpeg
        case unknow
    }
    
    var imageView: UIImageView?
    var selectedImage: UIImage?
    var imageType: ImageType = .unknow

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        descriptionTextField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(UploadViewController.keyboardWillChange(notification:)), name:
            UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UploadViewController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UploadViewController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        addImageFromLibrary()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //MARK: Add Image From Library
    private func addImageFromLibrary () {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageURL = info[.imageURL] as? URL
        
        if let imageURL = imageURL, let type = imageURL.typeIdentifier  {
            if type.contains(".jpeg") {
                self.imageType = .jpeg
            }
            else if type.contains(".png") {
                self.imageType = .png
            }
        }
        
        self.selectedImage = info[.editedImage] as? UIImage

        guard let selectedImage = self.selectedImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        if self.imageView != nil {
            self.imageView?.removeFromSuperview()
        }
        imageView = UIImageView(image: selectedImage)
        guard let imageView = self.imageView else {
            print("[Upload] - A problem occured on imageView loading")
            return
        }
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.frame = postView.bounds
        postView.addSubview(imageView)
        
        dismiss(animated: true, completion: nil)
    }

    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if self.titleTextField.text?.isEmpty == false && self.descriptionTextField.text?.isEmpty == false {
            self.addButton.isEnabled = true
        } else {
            self.addButton.isEnabled = false
        }
        return true
    }
    
    //MARK: Raise View when keyboard shows
    @objc func keyboardWillChange(notification: NSNotification) {
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -(view.frame.height - (descriptionTextField.frame.origin.y + descriptionTextField.frame.height))
        } else {
            view.frame.origin.y = 0
        }
    }

    //MARK: Change Selected Image
    @IBAction func changeSelectedImage(_ sender: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()

        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    //MARK: Add Post To Imgur
    @IBAction func addPostToImgur(_ sender: UIBarButtonItem) {
        let client = ImgurAPIClient()
        
        guard let image = selectedImage else {
            print("[Upload] - No selected image")
            return
        }
        guard let imageBase64 = convertImageToBase64(image: image, format: imageType) else {
            return
        }
        let title = self.titleTextField.text

        let description = self.descriptionTextField.text
        //MARK: FLO, C'EST LA AUE TU FAIS TES BAILS
        _ = try! client.uploadPhoto(photoBase64: imageBase64, title: title, description: description)
    
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController

        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: false, completion: nil)
    }
    
    //MARK: Image conversion
    private func convertImageToBase64(image: UIImage, format: ImageType) -> String? {
        var imageData: Data?

        switch format {
        case .jpeg:
            imageData = image.jpegData(compressionQuality: 0.4)
        case .png:
            imageData = image.pngData()
        case .unknow:
            return nil
        }
        guard let data = imageData else {
            print("[Upload] - An error occured on image conversion")
            return nil
        }
        guard let strBase64 = data.base64EncodedString() as String? else {
            print("[Upload] - An error occured on base conversion")
            return nil
        }
        return strBase64
    }
    
}
