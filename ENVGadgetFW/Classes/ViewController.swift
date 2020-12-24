//
//  ViewController.swift
//  ENVGadget
//
//  Created by Batıkan Sosun on 6.02.2020.
//  Copyright © 2020 Loodos. All rights reserved.
//

import UIKit
protocol EnviromentSettingsDelegate {
    func changedEnviroment()
}

class ViewController: UIViewController {
    
    var listObject:EnvironmentModel?
    var selectedChildList = ListChild()
    var selectedIndex = 0
    var picker = UIPickerView()
    var delegate:EnviromentSettingsDelegate?
    
    lazy var listTableView: UITableView = {
        let t = UITableView()
        t.backgroundColor = .white
        t.translatesAutoresizingMaskIntoConstraints = false
        t.delegate = self
        t.dataSource = self
        return t
    }()
    
    lazy var listTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default , reuseIdentifier: "LISTCELL")
        cell.textLabel?.text = ""
        return cell
    }()
    
    
    lazy var okButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("OK", for: .normal)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.backgroundColor = .blue
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        btn.addTarget(self, action: #selector(actions(sender:)), for: .touchUpInside)
        return btn
    }()
    
    
    var isUpdatedConstraint = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(listTableView)
        view.addSubview(okButton)
        listTableView.register(listTableViewCell.classForCoder, forCellReuseIdentifier: "LISTCELL")
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        view.addSubview(navBar)

        let navItem = UINavigationItem(title: "Enviroments")
      

        navBar.setItems([navItem], animated: false)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        listTableView.reloadData()
    }
    
    
    
    override func updateViewConstraints() {
        if !isUpdatedConstraint{
            
            isUpdatedConstraint = true
            
            listTableView.leftAnchor.constraint(equalTo: view.safeLeftAnchor).isActive = true
            listTableView.rightAnchor.constraint(equalTo: view.safeRightAnchor).isActive = true
            listTableView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 44).isActive = true
            
            okButton.topAnchor.constraint(equalTo: listTableView.bottomAnchor).isActive = true
            okButton.leftAnchor.constraint(equalTo: view.safeLeftAnchor).isActive = true
            okButton.rightAnchor.constraint(equalTo: view.safeRightAnchor).isActive = true
            okButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
            okButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
        }
        super.updateViewConstraints()
    }
    
    
    
    func createPickerView(childList:ListChild?) {
        picker.removeFromSuperview()
        var selectedIndexInPicker = 0
        if let list = childList {
            selectedChildList = list
            
            if let childList = list.childList {
                for (key, value) in childList.enumerated() {
                    if value.selected! {
                        selectedIndexInPicker = key
                        break
                    }
                }
            }
        }
        
        
        
        
        picker.delegate = self
        picker.dropShadow()
        picker.backgroundColor = .white
        view.addSubview(picker)
        picker.center = view.center
        picker.selectRow(selectedIndexInPicker, inComponent: 0, animated: true)
    }


}


extension ViewController{
    @objc func actions(sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}

extension ViewController:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        for (key, _) in selectedChildList.childList!.enumerated(){
            selectedChildList.childList?[key].selected = false
        }
        selectedChildList.childList?[row].selected = true
        listObject?.list?[selectedIndex].childList = selectedChildList.childList
        ENVGadgetManager.shared.list?.list?[selectedIndex].childList = selectedChildList.childList
        UserDefaults.standard.set(selectedChildList.childList?[row].value, forKey: "\(selectedChildList.key!)-value")
        UserDefaults.standard.set(selectedChildList.childList?[row].key, forKey: "\(selectedChildList.key!)-key")
        pickerView.removeFromSuperview()
        listTableView.reloadData()
        self.delegate?.changedEnviroment()
    }
}

extension ViewController:UIPickerViewDataSource{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let child  =  selectedChildList.childList{
            return child.count
        }
        return 0
    }

    @objc func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectedChildList.childList?[row].key
    }
}

extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let childList = listObject?.list?[indexPath.row]  {
            selectedIndex = indexPath.row
            createPickerView(childList: childList)
        }
        
    }
}
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = listObject?.list?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LISTCELL", for: indexPath) as UITableViewCell
        if let item = listObject?.list?[indexPath.row]  {
            guard let key = item.key else { return cell }
            let (selectedServiceURLsKey,_) = ENVGadgetManager.shared.getValueBy(key: key)
            cell.textLabel?.text = "\(key)  :  \(selectedServiceURLsKey)"
        }
        return cell
    }
}

extension UIView {
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 1
    layer.shadowOffset = CGSize.zero
    layer.shadowRadius = 5

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}


extension UIView {

  var safeTopAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return self.safeAreaLayoutGuide.topAnchor
    }
    return self.topAnchor
  }

  var safeLeftAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *){
      return self.safeAreaLayoutGuide.leftAnchor
    }
    return self.leftAnchor
  }

  var safeRightAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *){
      return self.safeAreaLayoutGuide.rightAnchor
    }
    return self.rightAnchor
  }

  var safeBottomAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return self.safeAreaLayoutGuide.bottomAnchor
    }
    return self.bottomAnchor
  }
}
