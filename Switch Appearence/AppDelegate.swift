//  AppDelegate.swift
//  Switch Appearence

//  Joel Johnson on 12/17/18
//  Copyright © 2018 Joel Johnson. All rights reserved.

import Cocoa
import Foundation // allows running applescripts from cocoa applications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // creates menu bar item
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    // initialize on app launch
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("Image"))
            
            // determine if system is in light or dark mode
            let out = shell(lPath: "/bin/bash", args:["-c", "defaults read -g AppleInterfaceStyle"])
            print(out)
            
            var lightSetting: String = "null"
            
            if out.contains("Dark") {
                lightSetting = "Toggle Light Mode"
            }
            else {
                lightSetting = "Toggle Dark Mode"
            }
            constructMenu(sysSetting: lightSetting) // calls function to build menu
            
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
 
    // function that switches dark/light mode
    @objc func switch_mode(_ sender: Any?) {
        let task = Process();
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["/Users/Joel/Switch Appearence/Switch Appearence/ToggleDarkMode.scpt"]
        task.launch()
    }
    
    // builds menu items
    func constructMenu(sysSetting: String) {
        // checks current system appearence
        // var cur_appearence = NSAppearance * appearance
    
        let menu = NSMenu() // menu object
        
        // keyEquivalent specifies key command, lowercase used cmd, uppercase uses cmd + shift
        //menu.addItem(NSMenuItem(title: "✔ Light Mode", action: #selector(AppDelegate.switch_mode(_:)), keyEquivalent: "l"))
        menu.addItem(NSMenuItem(title: sysSetting, action: #selector(AppDelegate.switch_mode(_:)), keyEquivalent: "d"))
        menu.addItem(NSMenuItem.separator())
        
        let a = NSMenuItem(title: "grayed out", action: #selector(AppDelegate.switch_mode(_:)), keyEquivalent: "")
        a.isHidden = false
        menu.addItem(a)
        
        let appList = buildAppList()
        
        var str = ""
        // keeps list of all appInfo objects
        var allAppInfos: [appInfo] = []
        for app in appList {
    
            let appName = bundleIDFor(appName: app)
            //print(appName)
            //print("is this light or dark?")
            let exempt = lightStatus(app: appName)
            print("end this\n\n")
            
            if exempt == true {
                str = "✔\(app)"
                //str = str.padding(toLength: 40, withPad: " ", startingAt: 0)
                //str += "✔"
            }
            else {
                str = "   \(app)"
            }
            let data = appInfo(name: app, bundleID: appName, exempt: exempt)
            allAppInfos.append(data)
          
            
            menu.addItem(NSMenuItem(title: "\(str)", action: #selector(AppDelegate.switch_mode(_:)), keyEquivalent: ""))
        }
        
        for app in allAppInfos {
            print("\(app.name) --> \(app.bundleID) --> \(app.exempt)")
        }
        getIcon(bundleID: "Mail.app")
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
        
    }
}
