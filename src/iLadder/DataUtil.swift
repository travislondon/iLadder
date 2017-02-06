//
//  DataUtil.swift
//  iLadder
//
//  Created by Travis London on 1/22/17.
//  Copyright © 2017 Travis London. All rights reserved.
//

import Foundation

public class DataUtil {
    public static func getResourcePath(subfolder : String, local: Bool) -> String {
        var filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)[0]
        #if os(tvOS)
        filePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true)[0]
        #endif
        if(local) {
            filePath = Bundle.main.bundlePath
        }
        return filePath + "/" + subfolder
    }
    #if FREE
    public static func loadLevelSetsFromCommunity() {
        // not available in free version
    }
    #else
    public static func loadLevelSetsFromCommunity() {
        do {
            let rootConfiguration = try String(contentsOf: URL(string: "https://raw.githubusercontent.com/travislondon/iLadder/master/Levels/LevelConfiguration.cfg")!)
            // downloaded the file, now get the level configuration files
            let levelSets = rootConfiguration.components(separatedBy: "\n")
            for levelSet in levelSets {
                let levelSetRootUrl = URL(fileURLWithPath: getResourcePath(subfolder: "Levels/" + levelSet, local: false))
                do {
                    if(!FileManager.default.fileExists(atPath: levelSetRootUrl.path)) {
                        try FileManager.default.createDirectory(atPath: levelSetRootUrl.path, withIntermediateDirectories: true, attributes: nil)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                let levelSetConfigUrl = levelSetRootUrl.appendingPathComponent((levelSetRootUrl.lastPathComponent))
                let setConfig = levelSetConfigUrl.appendingPathExtension("cfg")
                getFile(url: "https://raw.githubusercontent.com/travislondon/iLadder/master/Levels/" + levelSetConfigUrl.lastPathComponent + "/" + setConfig.lastPathComponent, localUrl: setConfig)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    #endif
    
    public static func getFile(url : String, localUrl : URL) {
        do {
            let remoteContents = try String(contentsOf: URL(string: url)!)
            try remoteContents.write(toFile: localUrl.path, atomically: false, encoding: .utf8)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    public static func getLevelFileFromCommunity(pathToLevel : String) -> URL? {
        let remoteUrl = URL.init(string: "https://raw.githubusercontent.com/travislondon/iLadder/master/Levels/" + pathToLevel.replacingOccurrences(of: " ", with: ""))
        return remoteUrl
    }

}
