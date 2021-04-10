//
//  StringExtension.swift
//  communityApplication
//
//  Created by Aravind on 31/01/2021.
//

import Foundation
import UIKit

extension String {
    func emailValidation()->Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}



/// MARK: - customTextfield for rounded corner thing in forgot password
@IBDesignable
open class customUITextField: UITextField {
    func setup() {
        self.borderStyle = .none
        self.backgroundColor = UIColor.white // Use anycolor that give you a 2d look.
        
        //To apply corner radius
        self.layer.cornerRadius = self.frame.size.height / 2
        
        //To apply border
        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        //To apply Shadow
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize.zero // Use any CGSize
        self.layer.shadowColor = UIColor.gray.cgColor
        
        //To apply padding
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
@IBDesignable class customUIView: UIView {
    func setup() {
        self.backgroundColor = UIColor.white // Use anycolor that give you a 2d look.
        
        //To apply corner radius
        self.layer.cornerRadius = 15
        
        //To apply border
        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        //To apply Shadow
        self.clipsToBounds = false
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize.zero // Use any CGSize
        self.layer.shadowColor = UIColor.gray.cgColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

@IBDesignable class customUITextView: UITextView {
    
    @IBInspectable var topInset: CGFloat = 0 {
            didSet {
                self.contentInset = UIEdgeInsets(top: topInset, left: self.contentInset.left, bottom: self.contentInset.bottom, right: self.contentInset.right)
            }
        }

        @IBInspectable var bottmInset: CGFloat = 0 {
            didSet {
                self.contentInset = UIEdgeInsets(top: self.contentInset.top, left: self.contentInset.left, bottom: bottmInset, right: self.contentInset.right)
            }
        }

        @IBInspectable var leftInset: CGFloat = 0 {
            didSet {
                self.contentInset = UIEdgeInsets(top: self.contentInset.top, left: leftInset, bottom: self.contentInset.bottom, right: self.contentInset.right)
            }
        }

        @IBInspectable var rightInset: CGFloat = 0 {
            didSet {
                self.contentInset = UIEdgeInsets(top: self.contentInset.top, left: self.contentInset.left, bottom: self.contentInset.bottom, right: rightInset)
            }
        }
    
    
    func setup() {
        self.backgroundColor = UIColor.white // Use anycolor that give you a 2d look.
        
        //To apply corner radius
        self.layer.cornerRadius = 15
        
        //To apply border
        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        //To apply Shadow
        self.clipsToBounds = false
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize.zero // Use any CGSize
        self.layer.shadowColor = UIColor.gray.cgColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

extension UITextView {

    private class PlaceholderLabel: UILabel { }

    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            label.textColor = .lightGray
            addSubview(label)
            return label
        }
    }

    @IBInspectable
    var placeholder: String {
        get {
            return subviews.compactMap( { $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.numberOfLines = 0
            let width = frame.width - textContainer.lineFragmentPadding * 2
            let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.frame.size.height = size.height
            placeholderLabel.frame.size.width = width
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)

            textStorage.delegate = self
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
             guard let uiColor = newValue else { return }
             layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = 1
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }

}

extension UITextView: NSTextStorageDelegate {

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }

}


extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day

        if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) minutes ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hours ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) days ago"
        }

        return "\(secondsAgo / week) weeks ago"
    }
    func numberOfDaysBetween() -> String {
        let numberOfDays = Calendar.current.dateComponents([.day], from: self, to: Date()).day
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.string(from: self)
        print(date)
        if numberOfDays == 0 {
            return "Today at \(date)"
        }else if numberOfDays == 1 {
            return "Yesterday at \(date)"
        }else {
            return "\(date)"
        }
    }
    func monthandYearCount() -> String {
        let numberOfMonth = Calendar.current.dateComponents([.month], from: self, to: Date()).month ?? 0
        let numberofYears = Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
        let numberofDays = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
        if numberofYears == 0 {
            if numberOfMonth == 0 {
                
                return numberofDays == 0 ? "Joined Today" : "Member for \(numberofDays) days"
            }
            return "Member for \(numberOfMonth) months"
        }
        return numberOfMonth == 0 ? "Member for \(numberofYears) years" : "Member for \(numberofYears) years, \(numberOfMonth) months"
        
    }
}
