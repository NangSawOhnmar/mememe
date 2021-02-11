//
//  ViewController.swift
//  MemeMe
//
//  Created by nang saw on 31/12/2020.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var pickImageButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageViewPicker: UIImageView!
    @IBOutlet weak var sharedButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    //textfield spec
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -2.0
    ]
    var activeTextField = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(topTextField, text: "TOP")
        setupTextField(bottomTextField, text: "BOTTOM")
        initialState()
        
        pickImageButton.width = self.view.bounds.width/2
        cameraButton.width = self.view.bounds.width/2
    }
    
    // Set text field attributes, delegate, and text
    func setupTextField(_ textField: UITextField, text: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.text = text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        //subscribe to the keyboard noti, to allow the view to raise when neccessary
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //unsubscribe to the keyboard noti
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentPickerViewController(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentPickerViewController(source: .camera)
    }
    
    @IBAction func shareAnImage(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    //cancel to share photo
    @IBAction func cancelToShare(_ sender: Any) {
        initialState()
    }
    
    //clear textfield when user start editing
    @IBAction func topTextField(_ sender: Any) {
        textFieldDidBeginEditing(topTextField)
    }
    
    @IBAction func bottomTextField(_ sender: Any) {
        textFieldDidBeginEditing(bottomTextField)
    }
    
    //create a `UIImagePickerController`, set its source, and present it
    func presentPickerViewController(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func save() {
        // update the meme
        let meme = Meme(topText: topTextField.text!,
                 bottomText: bottomTextField.text!,
                 originalImage:imageViewPicker.image!,
                 memedImage: generateMemedImage())
        
        // Add it to the meme array on the AppDelegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        self.navigationBar.isHidden = true
        self.toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        self.navigationBar.isHidden = false
        self.toolBar.isHidden = false
        
        return memedImage
    }
    
    func initialState(){
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imageViewPicker.image = nil
        sharedButton.isEnabled = false
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imageViewPicker.image = image
        }
        sharedButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //clear textfield when begin editing
        if textField == topTextField && textField.text == "TOP" || textField == bottomTextField && textField.text == "BOTTOM"{
            textField.text = ""
        }
        //to know current active textfield
        activeTextField = textField
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //dismiss keyboard when user press return
        textField.resignFirstResponder()
        return true
    }
    
    //keyboard hide/show setting
    @objc func keyboardWillShow(_ notification: Notification) {
        if activeTextField == bottomTextField {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    //get keyboard height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let keyboardSize = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
