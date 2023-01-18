//
//  AppState.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 18.01.2023.
//

import Foundation

class AppState{
    static let shared = AppState()
    static let name = "com.benyam.BenyamList.stateChanged"
    private init(){}
    func stateHasChanged(){
        NotificationCenter.default.post(name: NSNotification.Name(AppState.name), object: nil)
    }
}
