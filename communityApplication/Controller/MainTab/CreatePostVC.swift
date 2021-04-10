//
//  CreatePostVC.swift
//  communityApplication
//
//  Created by Aravind on 23/03/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SVProgressHUD

class CreatePostVC: UIViewController, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var problemImageView: UIImageView!
    
    
    
    lazy var presenter = CreatePostPresenter(with: self)
    var imagePicker = UIImagePickerController()
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.layer.borderWidth = 1.0
        questionTextView.layer.borderColor = UIColor.lightGray.cgColor
        questionTextView.text = "Enter your question....."
        questionTextView.textColor = .lightGray
        questionTextView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickPostBtn(_ sender: UIButton) {
        if CheckValidation() {
            SVProgressHUD.show(withStatus: "Uploading..")
            if problemImageView.image != nil {
                presenter.storeImage(title: titleTextField.text ?? "", question: questionTextView.text, image: problemImageView)
            }else {
                presenter.addProblemToDataBase(title: titleTextField.text ?? "", question: questionTextView.text)
            }
        }
        
    }
    func addProblemToDataBase(imageUrl: String = "") {
        let post: PostModel = PostModel()
        post.title = self.titleTextField.text ?? ""
        post.descriptionTitle = self.questionTextView.text
        post.uid = Auth.auth().currentUser?.uid ?? ""
        post.imageUrl = imageUrl
        post.createdAt = Date()
        self.ref = self.db.collection("post").addDocument(data: post.toFireBase()) { [self] err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                AppUtil.shared.getUserInfo(uid: Auth.auth().currentUser?.uid ?? "") { (user) in
                    self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "").updateData(["postCount": ((user.postCount ?? 0) + 1)])
                }
                BlankAllField()
            }
        }
    }
    func BlankAllField() {
        titleTextField.text = ""
        questionTextView.text = "Enter your question....."
        questionTextView.textColor = .lightGray
        problemImageView.image = nil
        uploadBtn.isHidden = false
        problemImageView.isHidden = true
        SVProgressHUD.dismiss()
        self.tabBarController?.selectedIndex = 0
    }
    
    func CheckValidation() -> Bool {
        if titleTextField.text?.isEmpty ?? true {
            //
            print("please enter Title")
            return false
        }
        if questionTextView.textColor == .lightGray || questionTextView.text.isEmpty {
            print("please enter question")
            return false
        }
        return true
    }
    @IBAction func onClickUploadBtn(_ sender: UIButton) {
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}
extension CreatePostVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        problemImageView.image  = tempImage
        problemImageView.isHidden = false
        uploadBtn.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension CreatePostVC: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == .lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText: String = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {
            textView.text = "Enter your question....."
            textView.textColor = .lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        else if textView.textColor == .lightGray && !text.isEmpty {
            textView.textColor = .black
            DispatchQueue.main.async {
                textView.text = text
            }
        }
        else {
            return true
        }
        return false
    }
}


extension CreatePostVC: CreatePostViewPresenter {
    func dataUploadedSuccessfully() {
        BlankAllField()
    }
}
