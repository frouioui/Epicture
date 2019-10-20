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
    
    var imageView: UIImageView?
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field’s user input through delegate callbacks.
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        
        // Listen for keyboard events
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
        // Hide the keyboard
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
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController

        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: false, completion: nil)
    }
    
}
