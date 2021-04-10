//
//  AnswerVC.swift
//  communityApplication
//
//  Created by Om on 31/03/21.
//

import UIKit
import SVProgressHUD

class AnswerVC: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var solutionTextView: customUITextView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var solutionImageView: UIImageView!
    
    lazy var presenter = AnswerPresenter(with: self)
    var postId: String?
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.postId = postId
    }
    
    @IBAction func onUploadButtonClick(_ sender: UIButton) {
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func onPostYourAnswerClick(_ sender: UIButton) {
        if solutionTextView.text.isEmpty {
            self.popupAlert(title: "Alert", message: "Please type youe solution first", actionTitles: ["Okay"], actions:[{action1 in
                self.dismiss(animated: true, completion: nil)
            }])
            return
        }
        if solutionImageView.image != nil {
            presenter.storeImage(answer: solutionTextView.text, image: solutionImageView)
        }else {
            presenter.addAnswerToDataBase(answerTitle: solutionTextView.text)
        }
        
    }
}

extension AnswerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        solutionImageView.image  = tempImage
        solutionImageView.isHidden = false
        uploadBtn.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
}



extension AnswerVC: AnswerViewPresenter {
    func dataUploadedSuccessfully() {
        self.dismiss(animated: true, completion: nil)
    }
}
