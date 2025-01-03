//
//  appVersionNumber.swift
//  句句
//
//  Created by Ben on 2022/4/23.
//

import Foundation

struct appVersionNumberHandler
{
    func hasUpdatedSinceLastRun() -> Bool
    {
        var bundleInfo = Bundle.main.infoDictionary!
        if let currentVersion = bundleInfo["CFBundleShortVersionString"] as? String {
            
            let defaults = UserDefaults.standard
            var array = defaults.array(forKey: "SavedIntArray")  as? [Double] ?? [Double]()
            
            print("current version \(currentVersion)")
            
            if !array.contains(Double(currentVersion)!)
            {
                array.append(Double(currentVersion)!)
            }
            
            defaults.set(array, forKey: "SavedIntArray")
            
            print("version list \(array)")
            
            let userDefaults = UserDefaults.standard
            if userDefaults.string(forKey: "currentVersion") == (currentVersion) {
                return false
            }
            userDefaults.set(currentVersion, forKey: "currentVersion")
            userDefaults.synchronize()
            return true
        }
        return false;
    }
    
    func hasPreviousVersionInRecord() -> Bool
    {
        let defaults = UserDefaults.standard
        var array = defaults.array(forKey: "SavedIntArray")  as? [Double] ?? [Double]()
        
        if !array.contains(6.0) || !array.contains(6.1) || !array.contains(6.2) || !array.contains(6.3) || !array.contains(6.4)
        {
            return true
        }else
        {
            return false
        }
    }
    

}
