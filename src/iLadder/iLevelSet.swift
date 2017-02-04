//
//  iLevelSet.swift
//  iLadder
//
//  Created by Travis London on 1/23/17.
//  Copyright © 2017 Travis London. All rights reserved.
//
import Foundation

public class iLevelSet {
  
    var name = ""
    var levelURLs = Array<URL>()
    var levelNames = Array<String>()
    var loadedLevels : Array<iLevel>?
    var community = false
    static var levelSets = Array<iLevelSet>()
    
    public init(name: String, community: Bool) {
        self.name = name
        self.community = community
        // initialize locala
        initializeDefinition()
    }
    
    static func getLevelSets() -> Array<iLevelSet>? {
        // get local level sets
        getLevelSets(community: false)
        // load levels sets from community
        DataUtil.loadLevelSetsFromCommunity()
        #if FREE
        #else
        // get community level sets
        getLevelSets(community: true)
        #endif
        return levelSets
    }
    
    static func getLevelSets(community: Bool) {
        let levelPath = DataUtil.getResourcePath(subfolder: "Levels/", local: !community)
        let url = URL(fileURLWithPath: levelPath)
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            let directories = directoryContents.filter{ $0.hasDirectoryPath }
            for directory in directories {
                let set = iLevelSet(name: directory.lastPathComponent, community: community)
                if(!set.levelURLs.isEmpty) {
                    levelSets.append(set)
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func initializeDefinition() {
        let levelPath = DataUtil.getResourcePath(subfolder: "Levels/" + name, local: !self.community)
        let url = URL(fileURLWithPath: levelPath)
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            orderLevels(contents: directoryContents)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func orderLevels(contents: [URL]) {
        let levelConfigurationFiles = contents.filter{ $0.pathExtension == "cfg" }
        if(!levelConfigurationFiles.isEmpty) {
            let levelConfigurationFile = levelConfigurationFiles.first
            let levelConfiguration = loadDataFromFile(file: levelConfigurationFile!)
            let orderedLevels = levelConfiguration?.components(separatedBy: "\n")
            for level in orderedLevels! {
                if(level == "") {
                    continue
                }
                let levelFiles = contents.filter{ $0.deletingPathExtension().lastPathComponent.contains(level.replacingOccurrences(of: " ", with: "")) && $0.pathExtension == "lvl"}
                if(levelFiles.isEmpty) {
                    // see if this is from the community
                    let levelFile = DataUtil.getLevelFileFromCommunity(pathToLevel: name + "/" + level + ".lvl")
                    if(levelFile != nil) {
                        levelNames.append(level)
                        levelURLs.append(levelFile!)
                    }
                } else {
                    levelNames.append(level)
                    levelURLs.append(levelFiles.first!)
                }
            }
        } else {
            levelURLs = contents.filter{ $0.pathExtension == "lvl" }
        }
    }
    
    func loadLevel(index : Int) -> iLevel {
        let levelURL = levelURLs[index]
        let levelName = levelNames[index]
        var levelContents = loadDataFromFile(file:levelURL)
        if(levelContents == nil) {
            levelContents = "Could not load level at: " + levelURL.path
        }
        let level = iLevel(name: levelName, contents: levelContents!)
        if(loadedLevels == nil) {
            loadedLevels = Array<iLevel>()
        }
        level.load()
        loadedLevels?.append(level)
        return level
    }
    
    func indexOf(name: String) -> Int {
        var count = 0
        for n in levelNames {
            if(n == name) {
                break
            }
            count += 1
        }
        return count
    }
    
    func loadDataFromFile(file: URL) -> String? {
        do {
            let contents = try String.init(contentsOf: file)
            return contents
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func getLevelSet(name : String) -> iLevelSet? {
        for set in levelSets {
            if(set.name == name) {
                return set
            }
        }
        return nil
    }
    
    func getLevelNames() -> Array<String> {
        return levelNames
    }
    
    func getLoadedLevelIndexOf(name: String) -> Int {
        var count = 0
        if(loadedLevels == nil) {
            return -1
        }
        for iLevel in loadedLevels! {
            if(iLevel.name == name) {
                break
            }
            count += 1
        }
        return -1
    }
    
    func getLevel(index: Int) -> iLevel {
        let name = levelNames[index]
        let loadedIndex = getLoadedLevelIndexOf(name: name)
        if(loadedIndex > 0) {
            if(loadedLevels != nil && (loadedLevels?.count)! > loadedIndex) {
                let loadedLevel = loadedLevels?[loadedIndex]
                if(loadedLevel != nil) {
                    return loadedLevel!
                }
            }
        }
        return loadLevel(index: index)
    }

}
