//
//  ViewController.swift
//  UITextView
//
//  Created by Tony on 17.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewButtomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        textView.isHidden = true
        textView.alpha = 0
        
        
       // textView.text = ""
        
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        textView.backgroundColor = self.view.backgroundColor
        textView.layer.cornerRadius = 10
        
        stepper.value = 17
        stepper.maximumValue = 25
        stepper.minimumValue = 10
        stepper.tintColor = .white
        stepper.backgroundColor = .gray
        stepper.layer.cornerRadius = 5
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents() //пока идет загрузка, интерфес не доступен
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        UIView.animate(withDuration: 0, delay: 5, options: .curveLinear,
                       animations: { self.textView.alpha = 1 })
        { (finished ) in
            self.activityIndicator.stopAnimating()
            self.textView.isHidden = false
            UIApplication.shared.endIgnoringInteractionEvents() // загрузка закончена, интерфейс доступен
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true) // скрытие клавиатуры для всех объектов
        //textView.resignFirstResponder() // скрытие клавиатуры только для текст вью (в данном случае)
    }
    
    @objc func updateTextView(notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: keyboardFrame.height - textViewButtomConstraint.constant,
                                                 right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    
    @IBAction func sizeFont(_ sender: UIStepper) {
        let font = textView.font?.fontName
        let fontSize = CGFloat(sender.value)
        
        textView.font = UIFont(name: font!, size: fontSize)
    }
    
    


}

extension ViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = .white
        textView.textColor = .gray
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = self.view.backgroundColor
        textView.textColor = .black
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        countLabel.text = "\(textView.text.count)"
        
        
        
        return textView.text.count + (text.count - range.length) <= 2000
    }
}


