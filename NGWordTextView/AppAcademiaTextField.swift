//
//  AppAcademiaNGTextField.swift
//  NGWordTextView
//
//  Created by 原田 礼朗 on 2018/08/06.
//  Copyright © 2018年 reo harada. All rights reserved.
//

import UIKit

class AppAcademiaNGTextField: UITextField, UITextFieldDelegate {
    
    var ngWordData = [String]()
    var warningLabel: UILabel!
    let warningText = "NGワードが入力されました"
    let warningTextColor = UIColor.red
    let fileName = "NGWord"
    let fileExtension = "txt"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        ngWordData = getDataFromFile(fileName).filter { $0 != "" }
        print(#function)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkTextWithTimer()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkTextWithTimer()
        return true
    }
    
    func checkTextWithTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (ti) in
            self.checkText()
        }
    }
    
    func checkText() {
        if let text = text {
            ngWordData.forEach({ (t) in
                if text.hasSuffix(t) || text.hasPrefix(t) || text.contains(t) {
                    if warningLabel == nil {
                        setUpWarningLabel()
                    }
                    warningLabel.isHidden = false
                    hideWarningLabel()
                    self.text = ""
                }
            })
        }
    }
    
    func setUpWarningLabel() {
        let rect = CGRect(x: 0, y: self.frame.size.height, width: 100, height: 100)
        warningLabel = UILabel(frame: rect)
        warningLabel.text = warningText
        warningLabel.textColor = warningTextColor
        warningLabel.isHidden = true
        warningLabel.sizeToFit()
        self.addSubview(warningLabel)
    }
    
    func hideWarningLabel() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (ti) in
            UIView.animate(withDuration: 0.5, animations: {
                self.warningLabel.alpha = 0
            }, completion: { (animated) in
                self.warningLabel.isHidden = true
                self.warningLabel.alpha = 1.0
            })
        }
    }

    func getDataFromFile(_ name: String) -> [String] {
        guard let filePath = Bundle.main.path(forResource: name, ofType: fileExtension) else {
            return [String]()
        }
        if let data =  try? String(contentsOfFile: filePath, encoding: String.Encoding.utf8) {
            let array = data.components(separatedBy: "\n")
            return array
        }
        return [String]()
    }
    

}
