//
//  ENVGadgetManager.swift
//  ENVGadget
//
//  Created by Batıkan Sosun on 6.02.2020.
//  Copyright © 2020 Loodos. All rights reserved.
//

import UIKit
import Foundation

struct ChildModel:Codable  {
    var key:String?
    var value:String?
    var selected:Bool?
}

struct ListChild:Codable  {
    var key:String?
    var childList:[ChildModel]?
}

public struct EnvironmentModel:Codable {
    var list:[ListChild]?
}

public enum ReturnType{
    case key
    case value
}




public class ENVGadgetManager:NSObject {
    
    private override init (){}
    
    public typealias CompletionHandler = (() -> Void)
    
    public static let shared = ENVGadgetManager()
    public var hasChangedEnviromentCompletion:CompletionHandler?
    public var list:EnvironmentModel?
    
    public func adjustGadget(){
        if let path = Bundle.main.path(forResource: "data", ofType: "json"){
            let url = URL.init(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                list = try JSONDecoder().decode(EnvironmentModel.self, from: data)
                gesture()
            } catch let err {
                print(err)
            }
        }else{
            print("Could not load data.json file")
        }
    }
    
    func openGagdet(list:EnvironmentModel){
        let viewController = ViewController()
        viewController.delegate = self
        viewController.listObject = list
        
        if #available(iOS 13, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
            guard let rootVC = keyWindow?.rootViewController else {
                return
            }
            rootVC.present(viewController, animated: true, completion: nil)
            
        } else {
            
            let delegate = UIApplication.shared.delegate
            
            guard let window = delegate?.window else {
                return
            }
            guard let rootVC = window?.rootViewController else {
                return
            }
            rootVC.present(viewController, animated: true, completion: nil)
        }
        
        
        
        
    }
    
    func gesture() {
        let swipeGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(didSwipe(recognizer:)))
        swipeGesture.direction = .right
        swipeGesture.numberOfTouchesRequired = 2
        UIApplication.shared.keyWindow?.addGestureRecognizer(swipeGesture)
    }
    
    @objc func didSwipe(recognizer:UISwipeGestureRecognizer){
        if recognizer.direction == .right {
            guard let l = list else { return }
            openGagdet(list: l)
        }
    }
    
    public func getValueBy(key:String) -> (String,String) {
        var returnValue = ""
        var returnKey = ""
        if let selectedValue = UserDefaults.standard.object(forKey: "\(key)-value") {
            returnValue = selectedValue as! String
        }
        if let selectedKey = UserDefaults.standard.object(forKey: "\(key)-key") {
            returnKey = selectedKey as! String
        }
        
        if !returnValue.isEmpty || !returnKey.isEmpty {
            return (returnKey,returnValue)
        }
        
        guard let listChild = list?.list  else { return ("","") }
        
        for item in listChild{
            if item.key == key {
                guard let childList = item.childList else { return ("","") }
                for child in childList {
                    if child.selected! {
                        returnValue = child.value ?? ""
                        returnKey = child.key ?? ""
                        break
                    }
                }
            }
        }
        return (returnKey,returnValue)
    }
}

extension ENVGadgetManager:EnviromentSettingsDelegate{
    func changedEnviroment() {
        self.hasChangedEnviromentCompletion?()
    }
}

