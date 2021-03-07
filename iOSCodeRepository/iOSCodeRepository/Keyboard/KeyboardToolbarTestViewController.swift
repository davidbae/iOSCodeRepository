//
//  KeyboardToolbarTestViewController.swift
//  iOSCodeRepository
//
//  Created by 배재형 on 2021/03/07.
//

import UIKit

class KeyboardToolbarTestViewController: UIViewController {
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var logTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Event에 따른 함수 호출 등록
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        //배경 View를 탭 하면, textField의 resigneFirstResponder를 호출해서, 키보드가 사라지게 한다.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.inputTextField, action: #selector(resignFirstResponder)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //키보드가 표시 될 때 호출 되는 함수
    @objc func keyboardWillShow(_ notification:NSNotification) {
        print(notification)
        info(name: "Keyboard Will beShown", with: notification)
        
        moveToolbarUp(with: notification)
    }
    @objc func keyboardDidShow(_ notification:NSNotification) {
        info(name: "Keyboard Was  Shown", with: notification)
    }
    
    //키보드가 사라질 때, 호출 되는 함수
    @objc func keyboardWillHide(_ notification:NSNotification) {
        info(name: "Keyboard Will beHidden", with: notification)
        
        moveToolbarDown(with: notification)
    }
    @objc func keyboardDidHide(_ notification:NSNotification) {
        info(name: "Keyboard Was  Hidden", with: notification)
    }
    
    //정보 표시
    fileprivate func info(name str:String, with notification:NSNotification) {
        if let userInfo = notification.userInfo {
            let frameBegin = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
            let frameEnd = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber ?? NSNumber.init(value: 0)
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber ).doubleValue
            
            let log = String("\(str) (\(Int(frameBegin.origin.x)),\(Int(frameBegin.origin.y)),\(Int(frameBegin.size.width)),\(Int(frameBegin.size.height))), (\(Int(frameEnd.origin.x)),\(Int(frameEnd.origin.y)),\(Int(frameEnd.size.width)),\(Int(frameEnd.size.height))) curve:\(curve), duration:\(duration)")
            
            //Debug창에 표시
            print(log)
            
            //View에 추가한 UITextView에 표시
            self.logTextView.text = self.logTextView.text + "\n" + log
            self.logTextView.scrollRangeToVisible(NSMakeRange(self.logTextView.text.count - 1, 1))
        }
    }
    
    fileprivate func moveToolbarUp(with notification:NSNotification) {
        self.moveToolBar(isUp: true, with: notification)
    }
    fileprivate func moveToolbarDown(with notification:NSNotification) {
        self.moveToolBar(isUp: false, with: notification)
    }
    
    fileprivate func moveToolBar(isUp up:Bool, with notification:NSNotification) {
        if let userInfo = notification.userInfo {
            //let beginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            let animationOptions = UIView.AnimationOptions(rawValue: (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uintValue)
            
            let frame = self.toolbar.frame

            let keyboardY = self.view.frame.height - endFrame.size.height
            print("keyboardY : \(keyboardY), toolbarY : \(self.toolbar.frame.origin.y)")
            //Toolbar의 frame.origin.y 값을 계산해 준다.
            // 표시할 때와, 사라질 때의 툴바의 Y위치를 계산
            let toolbarY = up ? keyboardY - frame.size.height : self.view.frame.height - frame.size.height
            let rect:CGRect = CGRect(x: frame.origin.x,
                                     y: toolbarY,
                                     width: frame.size.width,
                                     height: frame.size.height)
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           options: animationOptions,
                           animations: { [self] () -> Void in
                            self.toolbar.frame = rect
                           }, completion: nil)
        }else{
            //UserInfo가 없을 경우..
        }
    }
    

}
