//
//  PubilcSelectYearAlertView.swift
//  ZiHeBuilding
//
//  Created by MAC on 2022/04/11.
//

import UIKit

/// 屏幕宽
let kScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕高
let kScreenHeight = UIScreen.main.bounds.size.height
/// 宽度比
let kScalWidth = (kScreenWidth / 375)
/// 高度比
let kScalHeight = (kScreenHeight / 667)


/// RGB颜色
func kRGBColor(_ r:CGFloat,_ g : CGFloat, _ b : CGFloat, _ p : CGFloat) -> UIColor {
    
    return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: p)
}

class PubilcSelectYearAlertView: UIView {
    
    private let pickerH : CGFloat! = 260 * kScalHeight
    private var backgroundButton : UIButton = UIButton()
    private var genderPicker : UIPickerView = UIPickerView()
    private var dataArray : [String] = [String]()
    private var selectedItem : String = String()
    var selectStr:((_ string:String)->())?
    
    init(_ title:String,_ array:[String]) {
        self.dataArray = array
        
        
        let frame = CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight)
        super.init(frame: frame)
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        view.backgroundColor = .white
        self.addSubview(view)
        
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 44))
        bgView.backgroundColor = kRGBColor(235, 248, 253, 1)
        self.addSubview(bgView)
        
        let lab = UILabel()
        lab.frame = CGRect.init(x: 80, y: 0, width: SCREEN_WIDTH - 160, height: 44)
        lab.font = font16
        lab.textAlignment = .center
        lab.textColor = color333
        lab.text = title
        bgView.addSubview(lab)
        
        // 取消按钮
        let cancelButton = UIButton.init(type: UIButton.ButtonType.custom)
        cancelButton.frame = CGRect.init(x: 0, y: 0, width: 60, height: 44)
        cancelButton.titleLabel?.font = font16
        cancelButton.setTitle("Cancel", for: UIControl.State.normal)
        cancelButton.setTitleColor(color999, for: UIControl.State.normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: UIControl.Event.touchUpInside)
        bgView.addSubview(cancelButton)
        
        // 确定按钮
        let doneButton = UIButton.init(type: UIButton.ButtonType.custom)
        doneButton.frame = CGRect.init(x: kScreenWidth - 60, y: 0, width: 60, height: 44)
        doneButton.titleLabel?.font = font16
        doneButton.setTitle("Done", for: UIControl.State.normal)
        doneButton.setTitleColor(mainColor, for: UIControl.State.normal)
        doneButton.addTarget(self, action: #selector(doneButtonClick), for: UIControl.Event.touchUpInside)
        bgView.addSubview(doneButton)
        
        
        backgroundButton = UIButton.init(type: UIButton.ButtonType.system)
        backgroundButton.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        backgroundButton.backgroundColor = kRGBColor(0, 0, 0, 0)
        backgroundButton.addTarget(self, action: #selector(cancelButtonClick), for: UIControl.Event.touchUpInside)
        
        genderPicker = UIPickerView.init(frame: CGRect.init(x: 0, y: 44, width: kScreenWidth, height: pickerH - 44))
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.backgroundColor = UIColor.white
        self.addSubview(genderPicker)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+0.01) {
            DispatchQueue.main.async {
                self.genderPicker.selectRow(0, inComponent: 0, animated: true)
                self.pickerView(self.genderPicker, didSelectRow: 0, inComponent: 0)
            }
        }
        
       
    }
    // MARK: - Method
    
    /// 取消按钮点击方法
    @objc func cancelButtonClick(){
        self.pickerViewHidden()
    }
    
    /// 确定按钮点击方法
    @objc func doneButtonClick(){
        if self.selectStr != nil{
            self.selectStr!(self.selectedItem)
        }
        
        self.pickerViewHidden()
    }
    /// 展示pickerView
    public func pickerViewShow() {
        
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.addSubview(self.backgroundButton)
        keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.4, animations: {
            self.backgroundButton.backgroundColor = kRGBColor(0, 0, 0, 0.3)
            self.frame.origin.y = kScreenHeight - self.pickerH
        }) { (complete: Bool) in
            
        }
    }
    /// 隐藏pickerView
    public func pickerViewHidden() {
        
        UIView.animate(withDuration: 0.4, animations: {
            self.backgroundButton.backgroundColor = kRGBColor(0, 0, 0, 0)
            self.frame.origin.y = kScreenHeight
        }) { (complete:Bool) in
            self.removeFromSuperview()
            self.backgroundButton.removeFromSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PubilcSelectYearAlertView :UIPickerViewDelegate, UIPickerViewDataSource{
    // MARK: - UIPickerViewDelegate, UIPickerViewDataSource
    
    /// 返回列
    ///
    /// - Parameter pickerView: pickerView
    /// - Returns: 列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// 返回对应列的行数
    ///
    /// - Parameters:
    ///   - pickerView: pickerView
    ///   - component: 列
    /// - Returns: 行
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    /// 返回对应行的title
    ///
    /// - Parameters:
    ///   - pickerView: pickerView
    ///   - row: 行
    ///   - component: 列
    /// - Returns: title
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = dataArray[row]
        return title
    }
    
    /// 选择列、行
    ///
    /// - Parameters:
    ///   - pickerView: pickerView
    ///   - row: 行
    ///   - component: 列
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedItem = dataArray[row]
    }
}
