//
//  BasicViewController.swift
//  CodeBlue 5
//
//  Created by Kimberly on 8/16/18.
//  Copyright © 2018 Kimberly. All rights reserved.
//

import Cocoa

class BasicViewController: NSViewController, NSWindowDelegate {
    // MARK: - Variables
	let appDelegate = (NSApp.delegate as! AppDelegate)
    var appName = String()
	var backupFolder = String()
	var pictures = String()
    var appFile = String()
	var tempFile = String()
    var iapFile = String()
    var optionFile = String()
    var prefFile = String()
	let regularColor = NSColor(named: "RegularLabelColor")!
    
    
    // MARK: - Setting up
    func setup() {
        /* system files */
        appName = appDelegate.appName
		backupFolder = filePath1(name: "Backup")
		pictures = filePath1(name: "Pictures")
        appFile = filePath1(name: "CodeBlue")
		tempFile = filePath1(name: "Temp")
        iapFile = filePath1(name: "Receipt")
        optionFile = filePath1(name: "Options")
        prefFile = filePath1(name: "Preferences")
    }
    
    
    // MARK: - Functions 1: Files
    func filePathA(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths.first! as String
        let documentsURL = URL(fileURLWithPath: documentsDirectory)
        let url = documentsURL.appendingPathComponent(name)
        return url.path
    }
    
    func filePathB(name1: String, name2: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths.first! as String
        let documentsURL = URL(fileURLWithPath: documentsDirectory)
        let url = documentsURL.appendingPathComponent(name1).appendingPathComponent(name2)
        return url.path
    }
    
    func filePathBackup(name1: String, name2: String, name3: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths.first! as String
        let documentsURL = URL(fileURLWithPath: documentsDirectory)
        let url = documentsURL.appendingPathComponent(name1).appendingPathComponent(name2).appendingPathComponent(name3)
        return url.path
    }
    
    func filePath1(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths.first! as String
        let documentsURL = URL(fileURLWithPath: documentsDirectory)
        let url = documentsURL.appendingPathComponent(appName).appendingPathComponent(name)
        return url.path
    }
    
    func documentPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths.first! as NSString
        return documentsDirectory as String
    }
    
    func pathIsDirectory(path: String, packageAllowed: Bool) -> Bool {
        var isDir : ObjCBool = false
		if appDelegate.defaultFileManager.fileExists(atPath: path, isDirectory: &isDir) {
            if isDir.boolValue {
                // file exists and is a directory
                if NSWorkspace.shared.isFilePackage(atPath: path) {
                    if packageAllowed {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return true
                }
            } else {
                // file exists and is not a directory
                return false
            }
        } else {
            // file does not exist
            return false
        }
    }
    
    func pathIsPackage(path: String) -> Bool {
        var isDir: ObjCBool = false
		if appDelegate.defaultFileManager.fileExists(atPath: path, isDirectory: &isDir) {
            if isDir.boolValue {
                // file exists and is a directory
                if NSWorkspace.shared.isFilePackage(atPath: path) {
                    return true
                } else {
                    return false
                }
            } else {
                // file exists and is not a directory
                return false
            }
        } else {
            // file does not exist
            return false
        }
    }
    
    func pathIsFile(path: String, packageAllowed: Bool) -> Bool {
        var isDir: ObjCBool = false
		if appDelegate.defaultFileManager.fileExists(atPath: path, isDirectory: &isDir) {
            if isDir.boolValue {
                // file exists and is a directory
                if NSWorkspace.shared.isFilePackage(atPath: path) {
                    if packageAllowed {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            } else {
                // file exists and is not a directory
                return true
            }
        } else {
            // file does not exist
            return false
        }
    }
    
    func folderContents(path: String) -> [String] {
		if let filePaths = try? appDelegate.defaultFileManager.contentsOfDirectory(atPath: path) {
            return filePaths
        } else {
            return []
        }
    }
    
    func componentIsHidden(path: String) -> Bool {
        let start = path.startIndex
        let end = path.index(path.endIndex, offsetBy: 1 - path.count) // going backwards from the end
        let substring = path[start..<end]
        if substring == "." {
            return true
        } else {
            return false
        }
    }
    
    func getFileName(path: String) -> String {
        let f = (path as NSString).lastPathComponent
        return f
    }
    
    func getFileNameOnly(path: String) -> String? {
        let url = URL(fileURLWithPath: path)
        return url.deletingPathExtension().lastPathComponent
    }
    
    func getFileExtension(path: String) -> String {
        let ext = URL(fileURLWithPath: path).pathExtension
        return ext
    }
    
    func getParentPath(path: String) -> String {
        let fileURL: URL = URL(fileURLWithPath: path)
        let folderURL = fileURL.deletingLastPathComponent()
        return folderURL.path
    }
    
    func getParentURL(path: String) -> URL {
        let fileURL: URL = URL(fileURLWithPath: path)
        let folderURL = fileURL.deletingLastPathComponent()
        return folderURL
    }
    
    func getTextFileContent(path: String) -> String? {
        do {
            let contents = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return (contents != "") ? contents : nil
        } catch{
            print ("File Read Error")
            return nil
        }
    }
    
    func getFileSize(path: String) -> UInt64? {
        do {
			let attr = try appDelegate.defaultFileManager.attributesOfItem(atPath: path)
            let fileSize = attr[FileAttributeKey.size] as! UInt64
            return fileSize
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    func convertPathURL(path: String) -> URL {
        let url = URL(fileURLWithPath: path)
        return url
    }
    
    func makeUniqueFolder(folderPath: String, name: String, b: Bool) -> String {
        // b = YES => with underscore
        var newPath = String()
        var k = 0
        repeat {
            var numStr = String()
            if k == 0 {
                newPath = folderPath.appending("/").appendingFormat("%@", name)
            }
            else {
                if b {
                    numStr = "_" + String(k)
                } else {
                    numStr = String(k)
                }
                newPath = folderPath.appending("/").appendingFormat("%@", name).appendingFormat("%@", numStr)
            }
            k += 1
        } while FileHandler.pathExists(path: newPath)
        
        return newPath
    }
    
    func makeUniqueFolderWithExtension(folderPath: String, name: String, ext: String, b: Bool) -> String {
        // b = YES => with underscore
        var newPath = String()
        var k = 0
        repeat {
            var numStr = String()
            if k == 0 {
                newPath = folderPath.appending("/").appendingFormat("%@", name).appendingFormat(".%@", ext)
            }
            else {
                if b {
                    numStr = "_" + String(k)
                } else {
                    numStr = String(k)
                }
                newPath = folderPath.appending("/").appendingFormat("%@", name).appendingFormat("%@", numStr).appendingFormat(".%@", ext)
            }
            k += 1
        } while FileHandler.pathExists(path: newPath)
        
        return newPath
    }
    
    func convertURLtoBookmark(url: URL) -> Data? {
        do {
            let bookmark = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            return bookmark
        } catch let error as NSError {
            print("URL into Bookmark: \(error.description)")
            return nil
        }
    }
    
    func convertBookmarktoURL(bookmarkData: Data) -> URL? {
        do {
            var isStale = false
            let url = try URL.init(resolvingBookmarkData: bookmarkData, options: NSURL.BookmarkResolutionOptions.withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            return url
        } catch let error as NSError {
            print("Bookmark into URL: \(error.description)")
            return nil
        }
    }
    
    func convertToShellPath(path: String) -> String {
        let newPath = path.replacingOccurrences(of: " ", with: "\\ ")
        return newPath
    }
    
    func emptyFolder(folderURL: URL) {
		let defaultFileManager = appDelegate.defaultFileManager
		let fileURLs = defaultFileManager.enumerator(at: folderURL, includingPropertiesForKeys: nil)
        while let folderURL = fileURLs?.nextObject() {
            do {
                try defaultFileManager.removeItem(at: folderURL as! URL)
            } catch {
                print(error)
            }
        }
    }
    
    func deviceRemainingFreeSpaceInBytes() -> Int64? {
		let defaultFileManager = appDelegate.defaultFileManager
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? defaultFileManager.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
            else {
                // something failed
                return nil
        }
        return freeSize.int64Value
    }
    
    func readFileContent(path: String) -> Data? {
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            return data
        } catch let error as NSError {
            print("Error: \(error)")
        }
        return nil
    }
    
    
    // MARK: - Functions 2: String
    func removeWhiteSpaceLine(source: String) -> String {
        return source.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func numberStringFormatted(number: UInt64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        let formattedString = formatter.string(for: number)
        return formattedString!
    }
    
    func isEmailValid(_ email: String) -> Bool {
        //https;//medium.com/@darthpelo/email-validation-in-swift-3-0-acfebe4d879a
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
	func isURLValid(urlStr: String) -> Bool {
		//https://stackoverflow.com/questions/29106005/url-validation-in-swift
		let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
		let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
		let result = urlTest.evaluate(with: urlStr)
		return result
	}
    
    func isNameValid(name: String, len: Int, firstDotAllowed: Bool) -> Bool {
        if name == "" || name.contains(":") {
            return false
        } else {
            if name.count >= len {
                if let newString = name.replaceAll(find: " ", replace: "") {
                    if firstDotAllowed {
                        if newString != "" {
                            return true
                        } else {
                            return false
                        }
                    } else {
                        if newString != "" && newString.first != "." {
                            return true
                        } else {
                            return false
                        }
                    }
                } else {
                    return false
                }
            }
            else {
                return false
            }
        }
    }
	
	func isNameValid2(name: String, len: Int, firstDotAllowed: Bool) -> Bool {
	 if name == "" {
		 return false
	 } else {
		 if name.count >= len {
			 if let newString = name.replaceAll(find: " ", replace: "") {
				 if firstDotAllowed {
					 if newString != "" {
						 return true
					 } else {
						 return false
					 }
				 } else {
					 if newString != "" && newString.first != "." {
						 return true
					 } else {
						 return false
					 }
				 }
			 } else {
				 return false
			 }
		 }
		 else {
			 return false
		 }
	 }
 }
    
    func makeUniqueName1(folderPath: String, name: String, ext: String, b: Bool) -> String {
        // b = YES => with underscore
        var newPath = String()
        var k = 0
        repeat {
            var numStr = String()
            if k == 0 {
                newPath = folderPath.appending("/").appendingFormat("%@", name).appending(".").appendingFormat("%@", ext)
            }
            else {
                if b {
                    numStr = "_" + String(k)
                } else {
                    numStr = String(k)
                }
                newPath = folderPath.appending("/").appendingFormat("%@", name).appendingFormat("%@", numStr).appending(".").appendingFormat("%@", ext)
            }
            k += 1
        } while FileHandler.pathExists(path: newPath)
        
        return newPath
    }
        
    func makeUniqueName2(folderPath: String, name: String, ext: String, b: Bool) -> String {
        // b = YES => with underscore
        var newPath = String()
        var k = 0
        repeat {
            var numStr = String()
            if k == 0 {
                newPath = folderPath.appending("/").appendingFormat("%@", name).appending(".").appendingFormat("%@", ext)
            }
            else {
                if b {
                    if k < 10 {
                        numStr = "_00" + String(k)
                    }
                    else if k >= 10 && k < 100 {
                        numStr = "_0" + String(k)
                    }
                    else {
                        numStr = "_" + String(k)
                    }
                } else {
                    numStr = String(k)
                }
                newPath = folderPath.appending("/").appendingFormat("%@", name).appendingFormat("%@", numStr).appending(".").appendingFormat("%@", ext)
            }
            k += 1
        } while FileHandler.pathExists(path: newPath)
        
        return newPath
    }
    
    func makeUniqueName3(folderPath: String, name: String, ext: String, b: Bool) -> String {
        /* first screenshot starts with 001 */
        // b = YES => with underscore
        var newPath = String()
        var k = 1
        repeat {
            var numStr = String()
            if k == 0 {
                newPath = folderPath.appending("/").appendingFormat("%@", name).appendingFormat("_000").appending(".").appendingFormat("%@", ext)
            }
            else {
                if b {
                    if k < 10 {
                        numStr = "_00" + String(k)
                    }
                    else if k >= 10 && k < 100 {
                        numStr = "_0" + String(k)
                    }
                    else {
                        numStr = "_" + String(k)
                    }
                } else {
                    numStr = String(k)
                }
                newPath = folderPath.appending("/").appendingFormat("%@", name).appendingFormat("%@", numStr).appending(".").appendingFormat("%@", ext)
            }
            k += 1
        } while FileHandler.pathExists(path: newPath)
        
        return newPath
    }
    
    
    // MARK: - Functions 3: Graphics
    func getScreenSize(full: Bool) -> CGSize {
        var screenSize = CGSize()
        for screen in NSScreen.screens {
            if full {
                screenSize = screen.frame.size
            } else {
                screenSize = screen.visibleFrame.size
            }
        }
        return screenSize
    }
    
    func getImageFromPath(path: String) -> NSImage? {
        if let imageReps = NSBitmapImageRep.imageReps(withContentsOfFile: path) {
            var width = 0 as Int
            var height = 0 as Int
            for imageRep in imageReps {
                if imageRep.pixelsWide > width {
                    width = imageRep.pixelsWide
                }
                if imageRep.pixelsHigh > height {
                    height = imageRep.pixelsHigh
                }
            }
            let img = NSImage.init(size: CGSize(width: CGFloat(width), height: CGFloat(height)))
            img.addRepresentations(imageReps)
            return img
        }
        else {
            return nil
        }
        
        
        //let imageReps = NSBitmapImageRep()
    }
    
    func getImageSize(image: NSImage) -> CGSize? {
        /* image size will be doubled for a retina display */
        if let data = image.tiffRepresentation {
            if let imageRep = NSBitmapImageRep(data: data) {
                return CGSize(width: imageRep.pixelsWide, height: imageRep.pixelsHigh)
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    func imageFromView(view: NSView) -> NSImage? {
        let imgSize = CGSize.init(width: view.frame.size.width, height: view.frame.size.height)
        if let imageRep = view.bitmapImageRepForCachingDisplay(in: view.bounds) {
            imageRep.size = imgSize
            view.cacheDisplay(in: view.bounds, to: imageRep)
            let image = NSImage.init(size: imgSize)
            image.addRepresentation(imageRep)
            return image
        } else {
            return nil
        }
    }
    
    func getColorAtClick(view: NSView, clickAt: CGPoint) -> NSColor? {
        // https://stackoverflow.com/questions/1160229/how-to-get-the-color-of-a-pixel-in-an-uiview
        //let cgcolorSpace = NSColorSpaceName.deviceRGB
        let cgColorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        var pixelData: [UInt8] = [0, 0, 0, 0]
        if let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: cgColorSpace, bitmapInfo: bitmapInfo.rawValue) {
            context.translateBy(x: -clickAt.x, y: -clickAt.y)
            view.layer?.render(in: context)
            let red: CGFloat = CGFloat(pixelData[0]) / CGFloat(255.0)
            let green: CGFloat = CGFloat(pixelData[1]) / CGFloat(255.0)
            let blue: CGFloat = CGFloat(pixelData[2]) / CGFloat(255.0)
            let alpha: CGFloat = CGFloat(pixelData[3]) / CGFloat(255.0)
            let color = NSColor(deviceRed: red, green: green, blue: blue, alpha: alpha)
            return color
        }
        return nil
    }
    
    func makeColorRGB(color: NSColor) -> NSColor? {
        let colorSpaceMode = CGColorSpaceCreateDeviceRGB()
        let newCGColor = CGColor(colorSpace: colorSpaceMode, components: color.cgColor.components!)
        if let newColor = NSColor.init(cgColor: newCGColor!) {
            return newColor
        } else {
            return nil
        }
    }
    
    func overImage(bottomImage: NSImage, topImage: NSImage, point: CGPoint) -> NSImage {
        let newImage = NSImage.init(size: bottomImage.size)
        newImage.lockFocus()
        bottomImage.draw(at: CGPoint.zero, from: CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height), operation: .sourceOver, fraction: 1.0)
        topImage.draw(at: point, from: CGRect(x: 0, y: 0, width: topImage.size.width, height: topImage.size.height), operation: .sourceOver, fraction: 1.0)
        newImage.unlockFocus()
        return newImage
    }
    
    func appendImage(baseImage: NSImage, nextImage: NSImage) -> NSImage {
        var newSize = CGSize()
        if baseImage.size.height > nextImage.size.height {
            newSize = CGSize(width: baseImage.size.width + nextImage.size.width, height: baseImage.size.height)
            let newImage = NSImage.init(size: newSize)
            newImage.lockFocus()
            baseImage.draw(at: CGPoint.zero, from: CGRect(x: 0, y: 0, width: baseImage.size.width, height: baseImage.size.height), operation: .sourceOver, fraction: 1.0)
            nextImage.draw(at: CGPoint(x: baseImage.size.width, y: 0), from: CGRect(x: 0, y: 0, width: nextImage.size.width, height: nextImage.size.height), operation: .sourceOver, fraction: 1.0)
            newImage.unlockFocus()
            return newImage
        } else {
            newSize = CGSize(width: baseImage.size.width + nextImage.size.width, height: nextImage.size.height)
            let newImage = NSImage.init(size: newSize)
            newImage.lockFocus()
            baseImage.draw(at: CGPoint.zero, from: CGRect(x: 0, y: 0, width: baseImage.size.width, height: baseImage.size.height), operation: .sourceOver, fraction: 1.0)
            nextImage.draw(at: CGPoint(x: baseImage.size.width, y: 0), from: CGRect(x: 0, y: 0, width: nextImage.size.width, height: nextImage.size.height), operation: .sourceOver, fraction: 1.0)
            newImage.unlockFocus()
            return newImage
        }
    }
    
    func makeCIImage(image: NSImage) -> CIImage {
        var newRect = CGRect(origin: CGPoint.zero, size: CGSize(width: image.size.width, height: image.size.height))
        let imageRef = image.cgImage(forProposedRect: &newRect, context: NSGraphicsContext.current, hints: nil)
        return CIImage.init(cgImage: imageRef!)
    }
    
    func makeCIImageFromURL(url: URL) -> CIImage {
        return CIImage(contentsOf: url)!
    }
    
    func convertNSImageCIImage(image: NSImage) -> CIImage {
        return CIImage(data: image.tiffRepresentation!)!
    }
    
    func convertCIImageNSImage(ciImage: CIImage) -> NSImage {
        let rep: NSCIImageRep = NSCIImageRep(ciImage: ciImage)
        let image: NSImage = NSImage(size: rep.size)
        image.addRepresentation(rep)
        return image
    }
    
    func outerShadowImage(image: NSImage, blurRadius: CGFloat, color: NSColor, alpha: CGFloat) -> NSImage {
        let margin = blurRadius * 1.25
        let scale = NSScreen.main?.backingScaleFactor
        let imageRep = NSBitmapImageRep(data: image.tiffRepresentation!)
        let dotSize = CGSize(width: CGFloat((imageRep?.pixelsWide)!)/scale!, height: CGFloat((imageRep?.pixelsHigh)!)/scale!)
        var newRect = CGRect.zero
        newRect.size.width = dotSize.width + margin * 2
        newRect.size.height = dotSize.height + margin * 2
        let newImage = NSImage.init(size: newRect.size)
        newImage.lockFocus()
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current?.imageInterpolation = NSImageInterpolation.high
        
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadow.shadowBlurRadius = blurRadius
        shadow.shadowColor = color.withAlphaComponent(alpha)
        shadow.set()
        
        var drawRect = NSRect()
        drawRect.origin = CGPoint(x: margin, y: margin)
        drawRect.size = dotSize
        image.draw(in: drawRect, from: CGRect.zero, operation: .sourceOver, fraction: 1.0)
        
        NSGraphicsContext.restoreGraphicsState()
        newImage.unlockFocus()
        return newImage
    }
    
    func borderImage(sourceImage: NSImage, border1: CGFloat, border2: CGFloat, color: NSColor) -> NSImage {
        let newSize = CGSize(width: sourceImage.size.width + border1 * 2, height: sourceImage.size.height + border2 * 2)
        let point = CGPoint(x: border1, y: border2)
        let rect = CGRect(x: 0, y: 0, width: sourceImage.size.width, height: sourceImage.size.height)
        let newImage = NSImage.init(size: newSize)
        newImage.lockFocus()
        color.set()
        CGRect(origin: CGPoint.zero, size: newSize).fill()
        NSGraphicsContext.current?.imageInterpolation = NSImageInterpolation.high
        sourceImage.draw(at: point, from: rect, operation: .sourceOver, fraction: 1.0)
        newImage.unlockFocus()
        return newImage
    }
    
    func createColorImage(size: CGSize, color: NSColor) -> NSImage? {
        /* translucent-color-resistent */
        let image = NSImage.init(size: size)
        if let rep = NSBitmapImageRep.init(bitmapDataPlanes: nil, pixelsWide: Int(size.width), pixelsHigh: Int(size.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSColorSpaceName.calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0) {
            image.addRepresentation(rep)
            image.lockFocus()
            color.set()
            NSRect(origin: .zero, size: size).fill()
            image.unlockFocus()
            return image
        } else {
            return nil
        }
    }
    
    func adjustSatBriConImage(inputImage: NSImage, hue: CGFloat, sat: CGFloat, bri: CGFloat, con: CGFloat) -> NSImage {
        let ciImage = CIImage(data: inputImage.tiffRepresentation!)!
        let hueRadians = hue / 180.0 * .pi
        let hueFilter = CIFilter(name: "CIHueAdjust")
        hueFilter?.setValue(ciImage, forKey: "inputImage")
        hueFilter?.setValue(hueRadians, forKey: "inputAngle")
        let hueOutput = hueFilter?.outputImage
        
        let colorFilter = CIFilter(name: "CIColorControls")
        colorFilter?.setValue(hueOutput, forKey: "inputImage")
        colorFilter?.setValue(sat, forKey: "inputSaturation")
        colorFilter?.setValue(bri, forKey: "inputBrightness")
        colorFilter?.setValue(con, forKey: "inputContrast")
        let colorOutput = colorFilter?.outputImage
        let rep: NSCIImageRep = NSCIImageRep(ciImage: colorOutput!)
        let image: NSImage = NSImage(size: rep.size)
        image.addRepresentation(rep)
        return image
    }
    
    func degreesToRadians(degree: CGFloat) -> CGFloat {
        return degree / 180.0 * .pi
    }
    
    func imageCrop(sourceImage: NSImage, rect: CGRect, newSize: CGSize) -> NSImage {
        /* making a rectangular new image with a size of newSize */
        let image = NSImage.init(size: newSize)
        let newRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
        image.lockFocus()
        sourceImage.draw(at: CGPoint.zero, from: newRect, operation: NSCompositingOperation.sourceOver, fraction: 1.0)
        image.unlockFocus()
        return image
    }
    
    func clipImage(sourceImage: NSImage, rect: CGRect) -> NSImage {
        /* creating a rect hole maintaining the original image size */
        sourceImage.lockFocus()
        rect.fill(using: .clear)
        sourceImage.unlockFocus()
        return sourceImage
    }
    
    func saveImageToDisk(image: NSImage, destURL: URL) {
        if let imageData = NSBitmapImageRep(data: image.tiffRepresentation!)?.representation(using: .png, properties: [:]) {
            try? imageData.write(to: destURL)
        }
    }
    
    func imageCutCorners(image: NSImage, roundX: CGFloat, roundY: CGFloat) -> NSImage {
        let newSize = CGSize(width: image.size.width, height: image.size.height)
        let finalImage = NSImage(size: newSize)
        finalImage.lockFocus()
        let currentContext = NSGraphicsContext.current
        currentContext?.imageInterpolation = .high
        let imageRect = CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height))
        let clipPath = NSBezierPath.init(roundedRect: imageRect, xRadius: roundX, yRadius: roundY)
        clipPath.windingRule = .evenOdd
        clipPath.addClip()
        image.draw(at: CGPoint.zero, from: imageRect, operation: .sourceOver, fraction: 1.0)
        finalImage.unlockFocus()
        return finalImage
    }
    
    func clipImageWithPath(image: NSImage, clipPath: NSBezierPath) -> NSImage {
        let newSize = CGSize(width: image.size.width, height: image.size.height)
        let finalImage = NSImage(size: newSize)
        finalImage.lockFocus()
        let currentContext = NSGraphicsContext.current
        currentContext?.imageInterpolation = .high
        let imageRect = CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height))
        clipPath.addClip()
        image.draw(at: CGPoint.zero, from: imageRect, operation: .sourceOver, fraction: 1.0)
        finalImage.unlockFocus()
        return finalImage
    }
    
    
    // MARK: - Functions 8: Others
    func makeFont(name: String, type: String, size: CGFloat) -> NSFont {
        guard let fontPath = Bundle.main.path(forResource: name, ofType: type) else {
            print("Can't find the font file!")
            return NSFont.systemFont(ofSize: size)
        }
        guard let dataProvider = CGDataProvider(filename: fontPath) else {
            print("Can't create CGDataProvider with file name!")
            return NSFont.systemFont(ofSize: size)
        }
        
        let fontRef = CGFont(dataProvider)
        let fontCore = CTFontCreateWithGraphicsFont(fontRef!, size, nil, nil)
        return fontCore as NSFont
    }
    
    func setButtonText(color: NSColor, fontName: String, fontSize: CGFloat, button: NSButton) -> Void {
        let atext: NSMutableAttributedString = NSMutableAttributedString.init(attributedString: button.attributedTitle)
        let titleRange: NSRange = NSMakeRange(0, atext.length)
        atext.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: titleRange)
        atext.addAttribute(NSAttributedString.Key.font, value: NSFont.init(name: fontName, size: fontSize)!, range: titleRange)
        button.attributedTitle = atext
    }
    
    func getCurrentPbuttonItem(popupButton: NSPopUpButton) -> String {
        let selectedIndex: Int = popupButton.indexOfSelectedItem
        let title: String = popupButton.itemTitle(at: selectedIndex)
        return title
    }
    
    func getPbuttonItemAt(popupButton: NSPopUpButton, index: Int) -> String {
        let title: String = popupButton.itemTitle(at: index)
        return title
    }
    
    func getPbuttonTextIndex(popupButton: NSPopUpButton, searchText: String) -> Int {
        // finding the index of a string on a popupmenu control //
        var index = -1 as Int
        for i in 0..<popupButton.itemTitles.count {
            let itemTitle: String = popupButton.itemTitle(at: i)
            if itemTitle == searchText {
                index = i
                break
            }
        }
        return index
    }
    
    func addImageToPopupButton(title: String, image: NSImage, popupButton: NSPopUpButton) {
        let menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        menuItem.image = image
        popupButton.menu?.addItem(menuItem)
    }
    
    func makeColorPopupMenu(popupMenu: NSPopUpButton) {
        var color = NSColor()
        let titleArray = [NSLocalizedString("BasicViewColorPopupColor0", comment: ""), NSLocalizedString("BasicViewColorPopupColor1", comment: ""), NSLocalizedString("BasicViewColorPopupColor2", comment: ""), NSLocalizedString("BasicViewColorPopupColor3", comment: ""), NSLocalizedString("BasicViewColorPopupColor4", comment: ""), NSLocalizedString("BasicViewColorPopupColor5", comment: ""), NSLocalizedString("BasicViewColorPopupColor6", comment: ""), NSLocalizedString("BasicViewColorPopupColor7", comment: ""), NSLocalizedString("BasicViewColorPopupColor8", comment: ""), NSLocalizedString("BasicViewColorPopupColor9", comment: ""), NSLocalizedString("BasicViewColorPopupColor10", comment: ""), NSLocalizedString("BasicViewColorPopupColor11", comment: ""), NSLocalizedString("BasicViewColorPopupColor12", comment: ""), NSLocalizedString("BasicViewColorPopupColor13", comment: ""), NSLocalizedString("BasicViewColorPopupColor14", comment: ""), NSLocalizedString("BasicViewColorPopupColor15", comment: ""), NSLocalizedString("BasicViewColorPopupColor16", comment: ""), NSLocalizedString("BasicViewColorPopupColor17", comment: ""), NSLocalizedString("BasicViewColorPopupColor18", comment: ""), NSLocalizedString("BasicViewColorPopupColor19", comment: ""), NSLocalizedString("BasicViewColorPopupColor20", comment: ""), NSLocalizedString("BasicViewColorPopupColor21", comment: ""), NSLocalizedString("BasicViewColorPopupColor22", comment: ""), NSLocalizedString("BasicViewColorPopupColor23", comment: ""), NSLocalizedString("BasicViewColorPopupColor24", comment: ""), NSLocalizedString("BasicViewColorPopupColor25", comment: ""), NSLocalizedString("BasicViewColorPopupColor26", comment: ""), NSLocalizedString("BasicViewColorPopupColor27", comment: ""), NSLocalizedString("BasicViewColorPopupColor28", comment: ""), NSLocalizedString("BasicViewColorPopupColor29", comment: ""), NSLocalizedString("BasicViewColorPopupColor30", comment: ""), NSLocalizedString("BasicViewColorPopupColor31", comment: ""), NSLocalizedString("BasicViewColorPopupColor32", comment: ""), NSLocalizedString("BasicViewColorPopupColor33", comment: ""), NSLocalizedString("BasicViewColorPopupColor34", comment: ""), NSLocalizedString("BasicViewColorPopupColor35", comment: ""), NSLocalizedString("BasicViewColorPopupColor36", comment: ""), NSLocalizedString("BasicViewColorPopupColor37", comment: ""), NSLocalizedString("BasicViewColorPopupColor38", comment: ""), NSLocalizedString("BasicViewColorPopupColor39", comment: "")]
        let botImage = NSImage.makeColorImage(color: NSColor.black, size: CGSize(width: 16.0, height: 10.0))
        for i in 0..<12 {
            if i == 0 { color = NSColor.white }
            else if i == 1 { color = NSColor.black }
            else if i == 2 { color = NSColor.gray }
            else if i == 3 { color = NSColor.blue }
            else if i == 4 { color = NSColor.red }
            else if i == 5 { color = NSColor.yellow }
            else if i == 6 { color = NSColor.green }
            else if i == 7 { color = NSColor.orange }
            else if i == 8 { color = NSColor.cyan }
            else if i == 9 { color = NSColor.brown }
            else if i == 10 { color = NSColor.magenta }
            else if i == 11 { color = NSColor.purple }
            
            let topImage = NSImage.makeColorImage(color: color, size: CGSize(width: 14.0, height: 8.0))
            let newImage = overImage(bottomImage: botImage, topImage: topImage, point: CGPoint(x: 1, y: 1))
            let menuItem = NSMenuItem(title: titleArray[i], action: nil, keyEquivalent: "")
            menuItem.image = newImage
            popupMenu.menu?.addItem(menuItem)
        }
    }
    
    func makeColorPopupMenu2(popupMenu: NSPopUpButton) {
        // REF: http-//www.rapidtables.com/web/color/RGB_Color.htm
        var color = NSColor()
        let titleArray = [NSLocalizedString("BasicViewColorPopupColor0", comment: ""), NSLocalizedString("BasicViewColorPopupColor1", comment: ""), NSLocalizedString("BasicViewColorPopupColor2", comment: ""), NSLocalizedString("BasicViewColorPopupColor3", comment: ""), NSLocalizedString("BasicViewColorPopupColor4", comment: ""), NSLocalizedString("BasicViewColorPopupColor5", comment: ""), NSLocalizedString("BasicViewColorPopupColor6", comment: ""), NSLocalizedString("BasicViewColorPopupColor7", comment: ""), NSLocalizedString("BasicViewColorPopupColor8", comment: ""), NSLocalizedString("BasicViewColorPopupColor9", comment: ""), NSLocalizedString("BasicViewColorPopupColor10", comment: ""), NSLocalizedString("BasicViewColorPopupColor11", comment: ""), NSLocalizedString("BasicViewColorPopupColor12", comment: ""), NSLocalizedString("BasicViewColorPopupColor13", comment: ""), NSLocalizedString("BasicViewColorPopupColor14", comment: ""), NSLocalizedString("BasicViewColorPopupColor15", comment: ""), NSLocalizedString("BasicViewColorPopupColor16", comment: ""), NSLocalizedString("BasicViewColorPopupColor17", comment: ""), NSLocalizedString("BasicViewColorPopupColor18", comment: ""), NSLocalizedString("BasicViewColorPopupColor19", comment: ""), NSLocalizedString("BasicViewColorPopupColor20", comment: ""), NSLocalizedString("BasicViewColorPopupColor21", comment: ""), NSLocalizedString("BasicViewColorPopupColor22", comment: ""), NSLocalizedString("BasicViewColorPopupColor23", comment: ""), NSLocalizedString("BasicViewColorPopupColor24", comment: ""), NSLocalizedString("BasicViewColorPopupColor25", comment: ""), NSLocalizedString("BasicViewColorPopupColor26", comment: ""), NSLocalizedString("BasicViewColorPopupColor27", comment: ""), NSLocalizedString("BasicViewColorPopupColor28", comment: ""), NSLocalizedString("BasicViewColorPopupColor29", comment: ""), NSLocalizedString("BasicViewColorPopupColor30", comment: ""), NSLocalizedString("BasicViewColorPopupColor31", comment: ""), NSLocalizedString("BasicViewColorPopupColor32", comment: ""), NSLocalizedString("BasicViewColorPopupColor33", comment: ""), NSLocalizedString("BasicViewColorPopupColor34", comment: ""), NSLocalizedString("BasicViewColorPopupColor35", comment: ""), NSLocalizedString("BasicViewColorPopupColor36", comment: ""), NSLocalizedString("BasicViewColorPopupColor37", comment: ""), NSLocalizedString("BasicViewColorPopupColor38", comment: ""), NSLocalizedString("BasicViewColorPopupColor39", comment: "")]
        let botImage = NSImage.makeColorImage(color: NSColor.black, size: CGSize(width: 16.0, height: 10.0))
        for i in 0..<36 {
            if i == 0 { color = NSColor.white }
            else if i == 1 { color = NSColor.black }
            else if i == 2 { color = NSColor.gray }
            else if i == 3 { color = NSColor.blue }
            else if i == 4 { color = NSColor.red }
            else if i == 5 { color = NSColor.yellow }
            else if i == 6 { color = NSColor.green }
            else if i == 7 { color = NSColor.orange }
            else if i == 8 { color = NSColor.cyan }
            else if i == 9 { color = NSColor.brown }
            else if i == 10 { color = NSColor.magenta }
            else if i == 11 { color = NSColor.purple }
            else if i == 12 { color = NSColor(red: 128/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1) } // Maroon
            else if i == 13 { color = NSColor(red: 220/255.0, green: 20/255.0, blue: 60/255.0, alpha: 1) } // Crimson
            else if i == 14 { color = NSColor(red: 255/255.0, green: 99/255.0, blue: 71/255.0, alpha: 1) } // Tomato
            else if i == 15 { color = NSColor(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1) } // Gold
            else if i == 16 { color = NSColor(red: 218/255.0, green: 165/255.0, blue: 32/255.0, alpha: 1) } // Golden rod
            else if i == 17 { color = NSColor(red: 240/255.0, green: 230/255.0, blue: 140/255.0, alpha: 1) } // Khaki
            else if i == 18 { color = NSColor(red: 128/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1) } // Olive
            else if i == 19 { color = NSColor(red: 154/255.0, green: 205/255.0, blue: 50/255.0, alpha: 1) } // Yellow green
            else if i == 20 { color = NSColor(red: 124/255.0, green: 252/255.0, blue: 0/255.0, alpha: 1) } // Lawn green
            else if i == 21 { color = NSColor(red: 34/255.0, green: 139/255.0, blue: 34/255.0, alpha: 1) } // Forest green
            else if i == 22 { color = NSColor(red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1) } // Teal
                
            else if i == 23 { color = NSColor(red: 64/255.0, green: 224/255.0, blue: 208/255.0, alpha: 1) } // Turquoise
            else if i == 24 { color = NSColor(red: 70/255.0, green: 130/255.0, blue: 180/255.0, alpha: 1) } // Steel blue
            else if i == 25 { color = NSColor(red: 0/255.0, green: 191/255.0, blue: 255/255.0, alpha: 1) } // Deep sky blue
            else if i == 26 { color = NSColor(red: 0/255.0, green: 0/255.0, blue: 128/255.0, alpha: 1) } // Navy
            else if i == 27 { color = NSColor(red: 75/255.0, green: 0/255.0, blue: 130/255.0, alpha: 1) } // Indigo
            else if i == 28 { color = NSColor(red: 221/255.0, green: 160/255.0, blue: 221/255.0, alpha: 1) } // Plum
            else if i == 29 { color = NSColor(red: 255/255.0, green: 192/255.0, blue: 203/255.0, alpha: 1) } // Pink
            else if i == 30 { color = NSColor(red: 245/255.0, green: 245/255.0, blue: 220/255.0, alpha: 1) } // Beige
            else if i == 31 { color = NSColor(red: 210/255.0, green: 105/255.0, blue: 30/255.0, alpha: 1) } // Chocolate
            else if i == 32 { color = NSColor(red: 255/255.0, green: 255/255.0, blue: 240/255.0, alpha: 1) } // Ivory
            else if i == 33 { color = NSColor(red: 240/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1) } // Azure
            else if i == 34 { color = NSColor(red: 255/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1) } // Snow
            else if i == 35 { color = NSColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1) } // Silver
            let topImage = NSImage.makeColorImage(color: color, size: CGSize(width: 14.0, height: 8.0))
            let newImage = overImage(bottomImage: botImage, topImage: topImage, point: CGPoint(x: 1, y: 1))
            let menuItem = NSMenuItem(title: titleArray[i], action: nil, keyEquivalent: "")
            menuItem.image = newImage
            popupMenu.menu?.addItem(menuItem)
        }
    }
    
    func makeColorPopupMenu3(popupMenu: NSPopUpButton) {
        // REF: http-//www.rapidtables.com/web/color/RGB_Color.htm
        var color = NSColor()
        let titleArray = [NSLocalizedString("BasicViewColor3PopupColor0", comment: ""), NSLocalizedString("BasicViewColor3PopupColor1", comment: ""), NSLocalizedString("BasicViewColor3PopupColor2", comment: ""), NSLocalizedString("BasicViewColor3PopupColor3", comment: ""), NSLocalizedString("BasicViewColor3PopupColor4", comment: ""), NSLocalizedString("BasicViewColor3PopupColor5", comment: ""), NSLocalizedString("BasicViewColor3PopupColor6", comment: ""), NSLocalizedString("BasicViewColor3PopupColor7", comment: ""), NSLocalizedString("BasicViewColor3PopupColor8", comment: ""), NSLocalizedString("BasicViewColor3PopupColor9", comment: ""), NSLocalizedString("BasicViewColor3PopupColor10", comment: ""), NSLocalizedString("BasicViewColor3PopupColor11", comment: ""), NSLocalizedString("BasicViewColor3PopupColor12", comment: ""), NSLocalizedString("BasicViewColor3PopupColor13", comment: ""), NSLocalizedString("BasicViewColor3PopupColor14", comment: ""), NSLocalizedString("BasicViewColor3PopupColor15", comment: ""), NSLocalizedString("BasicViewColor3PopupColor16", comment: ""), NSLocalizedString("BasicViewColor3PopupColor17", comment: ""), NSLocalizedString("BasicViewColor3PopupColor18", comment: ""), NSLocalizedString("BasicViewColor3PopupColor19", comment: ""), NSLocalizedString("BasicViewColor3PopupColor20", comment: ""), NSLocalizedString("BasicViewColor3PopupColor21", comment: ""), NSLocalizedString("BasicViewColor3PopupColor22", comment: ""), NSLocalizedString("BasicViewColor3PopupColor23", comment: ""), NSLocalizedString("BasicViewColor3PopupColor24", comment: ""), NSLocalizedString("BasicViewColor3PopupColor25", comment: ""), NSLocalizedString("BasicViewColor3PopupColor26", comment: ""), NSLocalizedString("BasicViewColor3PopupColor27", comment: ""), NSLocalizedString("BasicViewColor3PopupColor28", comment: ""), NSLocalizedString("BasicViewColor3PopupColor29", comment: ""), NSLocalizedString("BasicViewColor3PopupColor30", comment: ""), NSLocalizedString("BasicViewColor3PopupColor31", comment: ""), NSLocalizedString("BasicViewColor3PopupColor32", comment: ""), NSLocalizedString("BasicViewColor3PopupColor33", comment: ""), NSLocalizedString("BasicViewColor3PopupColor34", comment: ""), NSLocalizedString("BasicViewColor3PopupColor35", comment: ""), NSLocalizedString("BasicViewColor3PopupColor36", comment: ""), NSLocalizedString("BasicViewColor3PopupColor37", comment: ""), NSLocalizedString("BasicViewColor3PopupColor38", comment: ""), NSLocalizedString("BasicViewColor3PopupColor39", comment: ""), NSLocalizedString("BasicViewColor3PopupColor40", comment: ""), NSLocalizedString("BasicViewColor3PopupColor41", comment: ""), NSLocalizedString("BasicViewColor3PopupColor42", comment: ""), NSLocalizedString("BasicViewColor3PopupColor43", comment: ""), NSLocalizedString("BasicViewColor3PopupColor44", comment: ""), NSLocalizedString("BasicViewColor3PopupColor45", comment: ""), NSLocalizedString("BasicViewColor3PopupColor46", comment: ""), NSLocalizedString("BasicViewColor3PopupColor47", comment: ""), NSLocalizedString("BasicViewColor3PopupColor48", comment: ""), NSLocalizedString("BasicViewColor3PopupColor49", comment: ""), NSLocalizedString("BasicViewColor3PopupColor50", comment: ""), NSLocalizedString("BasicViewColor3PopupColor51", comment: ""), NSLocalizedString("BasicViewColor3PopupColor52", comment: ""), NSLocalizedString("BasicViewColor3PopupColor53", comment: ""), NSLocalizedString("BasicViewColor3PopupColor54", comment: ""), NSLocalizedString("BasicViewColor3PopupColor55", comment: ""), NSLocalizedString("BasicViewColor3PopupColor56", comment: ""), NSLocalizedString("BasicViewColor3PopupColor57", comment: ""), NSLocalizedString("BasicViewColor3PopupColor58", comment: ""), NSLocalizedString("BasicViewColor3PopupColor59", comment: ""), NSLocalizedString("BasicViewColor3PopupColor60", comment: ""), NSLocalizedString("BasicViewColor3PopupColor61", comment: ""), NSLocalizedString("BasicViewColor3PopupColor62", comment: ""), NSLocalizedString("BasicViewColor3PopupColor63", comment: ""), NSLocalizedString("BasicViewColor3PopupColor64", comment: ""), NSLocalizedString("BasicViewColor3PopupColor65", comment: ""), NSLocalizedString("BasicViewColor3PopupColor66", comment: ""), NSLocalizedString("BasicViewColor3PopupColor67", comment: ""), NSLocalizedString("BasicViewColor3PopupColor68", comment: "")]
        let botImage = NSImage.makeColorImage(color: NSColor.black, size: CGSize(width: 16.0, height: 10.0))
        for i in 0..<69 {
            if i == 0 { color = NSColor.white }
            else if i == 1 { color = NSColor.black }
            else if i == 2 { color = NSColor.gray }
            else if i == 3 { color = NSColor.blue }
            else if i == 4 { color = NSColor.red }
            else if i == 5 { color = NSColor.yellow }
            else if i == 6 { color = NSColor.green }
            else if i == 7 { color = NSColor.orange }
            else if i == 8 { color = NSColor.cyan }
            else if i == 9 { color = NSColor.brown }
                
            else if i == 10 { color = NSColor.magenta }
            else if i == 11 { color = NSColor.purple }
            else if i == 12 { color = NSColor(red: 128/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1) } // Maroon
            else if i == 13 { color = NSColor(red: 220/255.0, green: 20/255.0, blue: 60/255.0, alpha: 1) } // Crimson
            else if i == 14 { color = NSColor(red: 255/255.0, green: 99/255.0, blue: 71/255.0, alpha: 1) } // Tomato
            else if i == 15 { color = NSColor(red: 255/255.0, green: 127/255.0, blue: 80/255.0, alpha: 1) } // Coral
            else if i == 16 { color = NSColor(red: 250/255.0, green: 128/255.0, blue: 114/255.0, alpha: 1) } // Salmon
            else if i == 17 { color = NSColor(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1) } // Gold
            else if i == 18 { color = NSColor(red: 218/255.0, green: 165/255.0, blue: 32/255.0, alpha: 1) } // Golden rod
            else if i == 19 { color = NSColor(red: 240/255.0, green: 230/255.0, blue: 140/255.0, alpha: 1) } // Khaki
                
            else if i == 20 { color = NSColor(red: 128/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1) } // Olive
            else if i == 21 { color = NSColor(red: 154/255.0, green: 205/255.0, blue: 50/255.0, alpha: 1) } // Yellow green
            else if i == 22 { color = NSColor(red: 124/255.0, green: 252/255.0, blue: 0/255.0, alpha: 1) } // Lawn green
            else if i == 23 { color = NSColor(red: 173/255.0, green: 255/255.0, blue: 47/255.0, alpha: 1) } // Green yellow
            else if i == 24 { color = NSColor(red: 0/255.0, green: 100/255.0, blue: 0/255.0, alpha: 1) } // Dark green
            else if i == 25 { color = NSColor(red: 0/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1) } // Green
            else if i == 26 { color = NSColor(red: 34/255.0, green: 139/255.0, blue: 34/255.0, alpha: 1) } // Forest green
            else if i == 27 { color = NSColor(red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1) } // Teal
            else if i == 28 { color = NSColor(red: 0/255.0, green: 139/255.0, blue: 139/255.0, alpha: 1) } // Dark cyan
            else if i == 29 { color = NSColor(red: 224/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1) } // Light cyan
                
            else if i == 30 { color = NSColor(red: 64/255.0, green: 224/255.0, blue: 208/255.0, alpha: 1) } // Turquoise
            else if i == 31 { color = NSColor(red: 70/255.0, green: 130/255.0, blue: 180/255.0, alpha: 1) } // Steel blue
            else if i == 32 { color = NSColor(red: 0/255.0, green: 191/255.0, blue: 255/255.0, alpha: 1) } // Deep sky blue
            else if i == 33 { color = NSColor(red: 173/255.0, green: 216/255.0, blue: 230/255.0, alpha: 1) } // Light blue
            else if i == 34 { color = NSColor(red: 135/255.0, green: 206/255.0, blue: 235/255.0, alpha: 1) } // Sky blue
            else if i == 35 { color = NSColor(red: 0/255.0, green: 0/255.0, blue: 128/255.0, alpha: 1) } // Navy
            else if i == 36 { color = NSColor(red: 65/255.0, green: 105/255.0, blue: 225/255.0, alpha: 1) } // Royal blue
            else if i == 37 { color = NSColor(red: 138/255.0, green: 43/255.0, blue: 226/255.0, alpha: 1) } // Blue violet
            else if i == 38 { color = NSColor(red: 75/255.0, green: 0/255.0, blue: 130/255.0, alpha: 1) } // Indigo
            else if i == 39 { color = NSColor(red: 216/255.0, green: 191/255.0, blue: 216/255.0, alpha: 1) } // Thistle
                
            else if i == 40 { color = NSColor(red: 221/255.0, green: 160/255.0, blue: 221/255.0, alpha: 1) } // Plum
            else if i == 41 { color = NSColor(red: 238/255.0, green: 130/255.0, blue: 238/255.0, alpha: 1) } // Violet
            else if i == 42 { color = NSColor(red: 218/255.0, green: 112/255.0, blue: 214/255.0, alpha: 1) } // Orchid
            else if i == 43 { color = NSColor(red: 255/255.0, green: 20/255.0, blue: 147/255.0, alpha: 1) } // Deep pink
            else if i == 44 { color = NSColor(red: 255/255.0, green: 105/255.0, blue: 180/255.0, alpha: 1) } // Hot pink
            else if i == 45 { color = NSColor(red: 255/255.0, green: 182/255.0, blue: 193/255.0, alpha: 1) } // Light pink
            else if i == 46 { color = NSColor(red: 255/255.0, green: 192/255.0, blue: 203/255.0, alpha: 1) } // Pink
            else if i == 47 { color = NSColor(red: 250/255.0, green: 235/255.0, blue: 215/255.0, alpha: 1) } // Antique white
            else if i == 48 { color = NSColor(red: 245/255.0, green: 245/255.0, blue: 220/255.0, alpha: 1) } // Beige
            else if i == 49 { color = NSColor(red: 255/255.0, green: 228/255.0, blue: 196/255.0, alpha: 1) } // Bisque
                
            else if i == 50 { color = NSColor(red: 245/255.0, green: 222/255.0, blue: 179/255.0, alpha: 1) } // Wheat
            else if i == 51 { color = NSColor(red: 255/255.0, green: 248/255.0, blue: 220/255.0, alpha: 1) } // Corn silk
            else if i == 52 { color = NSColor(red: 160/255.0, green: 82/255.0, blue: 45/255.0, alpha: 1) } // Sienna
            else if i == 53 { color = NSColor(red: 210/255.0, green: 105/255.0, blue: 30/255.0, alpha: 1) } // Chocolate
            else if i == 54 { color = NSColor(red: 210/255.0, green: 180/255.0, blue: 140/255.0, alpha: 1) } // Tan
            else if i == 55 { color = NSColor(red: 255/255.0, green: 228/255.0, blue: 181/255.0, alpha: 1) } // Moccasin
            else if i == 56 { color = NSColor(red: 250/255.0, green: 240/255.0, blue: 230/255.0, alpha: 1) } // Linen
            else if i == 57 { color = NSColor(red: 255/255.0, green: 245/255.0, blue: 238/255.0, alpha: 1) } // Sea shell
            else if i == 58 { color = NSColor(red: 245/255.0, green: 255/255.0, blue: 250/255.0, alpha: 1) } // Mint cream
            else if i == 59 { color = NSColor(red: 230/255.0, green: 230/255.0, blue: 250/255.0, alpha: 1) } // Lavender
                
            else if i == 60 { color = NSColor(red: 255/255.0, green: 250/255.0, blue: 240/255.0, alpha: 1) } // Floral white
            else if i == 61 { color = NSColor(red: 248/255.0, green: 248/255.0, blue: 255/255.0, alpha: 1) } // Ghost white
            else if i == 62 { color = NSColor(red: 240/255.0, green: 255/255.0, blue: 240/255.0, alpha: 1) } // Honeydew
            else if i == 63 { color = NSColor(red: 255/255.0, green: 255/255.0, blue: 240/255.0, alpha: 1) } // Ivory
            else if i == 64 { color = NSColor(red: 240/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1) } // Azure
            else if i == 65 { color = NSColor(red: 255/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1) } // Snow
            else if i == 66 { color = NSColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1) } // Silver
            else if i == 67 { color = NSColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1) } // Gainsboro
            else if i == 68 { color = NSColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1) } // White smoke
            let topImage = NSImage.makeColorImage(color: color, size: CGSize(width: 14.0, height: 8.0))
            let newImage = overImage(bottomImage: botImage, topImage: topImage, point: CGPoint(x: 1, y: 1))
            let menuItem = NSMenuItem(title: titleArray[i], action: nil, keyEquivalent: "")
            menuItem.image = newImage
            popupMenu.menu?.addItem(menuItem)
        }
    }
    
    func makeColorPopupMenu4(popupMenu: NSPopUpButton) {
        var color = NSColor()
        let titleArray = [NSLocalizedString("BasicViewColor4PopupColor0", comment: ""), NSLocalizedString("BasicViewColor4PopupColor1", comment: ""), NSLocalizedString("BasicViewColor4PopupColor2", comment: ""), NSLocalizedString("BasicViewColor4PopupColor3", comment: ""), NSLocalizedString("BasicViewColor4PopupColor4", comment: ""), NSLocalizedString("BasicViewColor4PopupColor5", comment: ""), NSLocalizedString("BasicViewColor4PopupColor6", comment: ""), NSLocalizedString("BasicViewColor4PopupColor7", comment: ""), NSLocalizedString("BasicViewColor4PopupColor8", comment: ""), NSLocalizedString("BasicViewColor4PopupColor9", comment: ""), NSLocalizedString("BasicViewColor4PopupColor10", comment: ""), NSLocalizedString("BasicViewColor4PopupColor11", comment: ""), NSLocalizedString("BasicViewColor4PopupColor12", comment: ""), NSLocalizedString("BasicViewColor4PopupColor13", comment: ""), NSLocalizedString("BasicViewColor4PopupColor14", comment: ""), NSLocalizedString("BasicViewColor4PopupColor15", comment: ""), NSLocalizedString("BasicViewColor4PopupColor16", comment: ""), NSLocalizedString("BasicViewColor4PopupColor17", comment: ""), NSLocalizedString("BasicViewColor4PopupColor18", comment: ""), NSLocalizedString("BasicViewColor4PopupColor19", comment: ""), NSLocalizedString("BasicViewColor4PopupColor20", comment: ""), NSLocalizedString("BasicViewColor4PopupColor21", comment: ""), NSLocalizedString("BasicViewColor4PopupColor22", comment: ""), NSLocalizedString("BasicViewColor4PopupColor23", comment: ""), NSLocalizedString("BasicViewColor4PopupColor24", comment: ""), NSLocalizedString("BasicViewColor4PopupColor25", comment: ""), NSLocalizedString("BasicViewColor4PopupColor26", comment: ""), NSLocalizedString("BasicViewColor4PopupColor27", comment: ""), NSLocalizedString("BasicViewColor4PopupColor28", comment: ""), NSLocalizedString("BasicViewColor4PopupColor29", comment: ""), NSLocalizedString("BasicViewColor4PopupColor30", comment: ""), NSLocalizedString("BasicViewColor4PopupColor31", comment: ""), NSLocalizedString("BasicViewColor4PopupColor32", comment: ""), NSLocalizedString("BasicViewColor4PopupColor33", comment: ""), NSLocalizedString("BasicViewColor4PopupColor34", comment: ""), NSLocalizedString("BasicViewColor4PopupColor35", comment: ""), NSLocalizedString("BasicViewColor4PopupColor36", comment: ""), NSLocalizedString("BasicViewColor4PopupColor37", comment: ""), NSLocalizedString("BasicViewColor4PopupColor38", comment: ""), NSLocalizedString("BasicViewColor4PopupColor39", comment: ""), NSLocalizedString("BasicViewColor4PopupColor40", comment: ""), NSLocalizedString("BasicViewColor4PopupColor41", comment: ""), NSLocalizedString("BasicViewColor4PopupColor42", comment: ""), NSLocalizedString("BasicViewColor4PopupColor43", comment: ""), NSLocalizedString("BasicViewColor4PopupColor44", comment: ""), NSLocalizedString("BasicViewColor4PopupColor45", comment: ""), NSLocalizedString("BasicViewColor4PopupColor46", comment: ""), NSLocalizedString("BasicViewColor4PopupColor47", comment: ""), NSLocalizedString("BasicViewColor4PopupColor48", comment: ""), NSLocalizedString("BasicViewColor4PopupColor49", comment: ""), NSLocalizedString("BasicViewColor4PopupColor50", comment: ""), NSLocalizedString("BasicViewColor4PopupColor51", comment: ""), NSLocalizedString("BasicViewColor4PopupColor52", comment: ""), NSLocalizedString("BasicViewColor4PopupColor53", comment: ""), NSLocalizedString("BasicViewColor4PopupColor54", comment: ""), NSLocalizedString("BasicViewColor4PopupColor55", comment: ""), NSLocalizedString("BasicViewColor4PopupColor56", comment: ""), NSLocalizedString("BasicViewColor4PopupColor57", comment: ""), NSLocalizedString("BasicViewColor4PopupColor58", comment: ""), NSLocalizedString("BasicViewColor4PopupColor59", comment: ""), NSLocalizedString("BasicViewColor4PopupColor60", comment: ""), NSLocalizedString("BasicViewColor4PopupColor61", comment: ""), NSLocalizedString("BasicViewColor4PopupColor62", comment: ""), NSLocalizedString("BasicViewColor4PopupColor63", comment: ""), NSLocalizedString("BasicViewColor4PopupColor64", comment: ""), NSLocalizedString("BasicViewColor4PopupColor65", comment: ""), NSLocalizedString("BasicViewColor4PopupColor66", comment: ""), NSLocalizedString("BasicViewColor4PopupColor67", comment: ""), NSLocalizedString("BasicViewColor4PopupColor68", comment: ""), NSLocalizedString("BasicViewColor4PopupColor69", comment: ""), NSLocalizedString("BasicViewColor4PopupColor70", comment: ""), NSLocalizedString("BasicViewColor4PopupColor71", comment: ""), NSLocalizedString("BasicViewColor4PopupColor72", comment: ""), NSLocalizedString("BasicViewColor4PopupColor73", comment: ""), NSLocalizedString("BasicViewColor4PopupColor74", comment: ""), NSLocalizedString("BasicViewColor4PopupColor75", comment: ""), NSLocalizedString("BasicViewColor4PopupColor76", comment: ""), NSLocalizedString("BasicViewColor4PopupColor77", comment: ""), NSLocalizedString("BasicViewColor4PopupColor78", comment: ""), NSLocalizedString("BasicViewColor4PopupColor79", comment: ""), NSLocalizedString("BasicViewColor4PopupColor80", comment: ""), NSLocalizedString("BasicViewColor4PopupColor81", comment: ""), NSLocalizedString("BasicViewColor4PopupColor82", comment: ""), NSLocalizedString("BasicViewColor4PopupColor82", comment: ""), NSLocalizedString("BasicViewColor4PopupColor84", comment: ""), NSLocalizedString("BasicViewColor4PopupColor85", comment: ""), NSLocalizedString("BasicViewColor4PopupColor86", comment: ""), NSLocalizedString("BasicViewColor4PopupColor87", comment: ""), NSLocalizedString("BasicViewColor4PopupColor88", comment: ""), NSLocalizedString("BasicViewColor4PopupColor89", comment: ""), NSLocalizedString("BasicViewColor4PopupColor90", comment: ""), NSLocalizedString("BasicViewColor4PopupColor91", comment: ""), NSLocalizedString("BasicViewColor4PopupColor92", comment: ""), NSLocalizedString("BasicViewColor4PopupColor93", comment: ""), NSLocalizedString("BasicViewColor4PopupColor94", comment: ""), NSLocalizedString("BasicViewColor4PopupColor95", comment: ""), NSLocalizedString("BasicViewColor4PopupColor96", comment: ""), NSLocalizedString("BasicViewColor4PopupColor97", comment: ""), NSLocalizedString("BasicViewColor4PopupColor98", comment: ""), NSLocalizedString("BasicViewColor4PopupColor99", comment: ""), NSLocalizedString("BasicViewColor4PopupColor100", comment: ""), NSLocalizedString("BasicViewColor4PopupColor101", comment: ""), NSLocalizedString("BasicViewColor4PopupColor102", comment: ""), NSLocalizedString("BasicViewColor4PopupColor103", comment: ""), NSLocalizedString("BasicViewColor4PopupColor104", comment: ""), NSLocalizedString("BasicViewColor4PopupColor105", comment: ""), NSLocalizedString("BasicViewColor4PopupColor106", comment: ""), NSLocalizedString("BasicViewColor4PopupColor107", comment: ""), NSLocalizedString("BasicViewColor4PopupColor108", comment: ""), NSLocalizedString("BasicViewColor4PopupColor109", comment: ""), NSLocalizedString("BasicViewColor4PopupColor110", comment: ""), NSLocalizedString("BasicViewColor4PopupColor111", comment: ""), NSLocalizedString("BasicViewColor4PopupColor112", comment: ""), NSLocalizedString("BasicViewColor4PopupColor113", comment: ""), NSLocalizedString("BasicViewColor4PopupColor114", comment: ""), NSLocalizedString("BasicViewColor4PopupColor115", comment: ""), NSLocalizedString("BasicViewColor4PopupColor116", comment: ""), NSLocalizedString("BasicViewColor4PopupColor117", comment: ""), NSLocalizedString("BasicViewColor4PopupColor118", comment: ""), NSLocalizedString("BasicViewColor4PopupColor119", comment: ""), NSLocalizedString("BasicViewColor4PopupColor120", comment: ""), NSLocalizedString("BasicViewColor4PopupColor121", comment: ""), NSLocalizedString("BasicViewColor4PopupColor122", comment: ""), NSLocalizedString("BasicViewColor4PopupColor123", comment: ""), NSLocalizedString("BasicViewColor4PopupColor124", comment: ""), NSLocalizedString("BasicViewColor4PopupColor125", comment: ""), NSLocalizedString("BasicViewColor4PopupColor126", comment: ""), NSLocalizedString("BasicViewColor4PopupColor127", comment: ""), NSLocalizedString("BasicViewColor4PopupColor128", comment: ""), NSLocalizedString("BasicViewColor4PopupColor129", comment: ""), NSLocalizedString("BasicViewColor4PopupColor130", comment: ""), NSLocalizedString("BasicViewColor4PopupColor131", comment: ""), NSLocalizedString("BasicViewColor4PopupColor132", comment: ""), NSLocalizedString("BasicViewColor4PopupColor133", comment: ""), NSLocalizedString("BasicViewColor4PopupColor134", comment: ""), NSLocalizedString("BasicViewColor4PopupColor135", comment: ""), NSLocalizedString("BasicViewColor4PopupColor136", comment: ""), NSLocalizedString("BasicViewColor4PopupColor137", comment: "")]
        let botImage = NSImage.makeColorImage(color: NSColor.black, size: CGSize(width: 16.0, height: 10.0))
        for i in 0..<138 {
            if i == 0 { color = NSColor(red: 128/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1) } // maroon
            else if i == 1 { color = NSColor(red: 139/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1) } // dark red
            else if i == 2 { color = NSColor(red: 165/255.0, green: 42/255.0, blue: 42/255.0, alpha: 1) } // brown
            else if i == 3 { color = NSColor(red: 178/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1) } // firebrick
            else if i == 4 { color = NSColor(red: 220/255.0, green: 20/255.0, blue: 60/255.0, alpha: 1) } // crimson
            else if i == 5 { color = NSColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1) } // red
            else if i == 6 { color = NSColor(red: 255/255.0, green: 99/255.0, blue: 71/255.0, alpha: 1) } // tomato
            else if i == 7 { color = NSColor(red: 255/255.0, green: 127/255.0, blue: 80/255.0, alpha: 1) } // coral
            else if i == 8 { color = NSColor(red: 205/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1) } // indian red
            else if i == 9 { color = NSColor(red: 240/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1) } // light coral
                
                /* 10 - 19 */
            else if i == 10 { color = NSColor(red: 233/255.0, green: 150/255.0, blue: 122/255.0, alpha: 1) } // dark salmon
            else if i == 11 { color = NSColor(red: 250/255.0, green: 128/255.0, blue: 114/255.0, alpha: 1) } // salmon
            else if i == 12 { color = NSColor(red: 255/255.0, green: 160/255.0, blue: 122/255.0, alpha: 1) } // light salmon
            else if i == 13 { color = NSColor(red: 255/255.0, green: 69/255.0, blue: 0/255.0, alpha: 1) } // orange red
            else if i == 14 { color = NSColor(red: 255/255.0, green: 140/255.0, blue: 0/255.0, alpha: 1) } // dark orange
            else if i == 15 { color = NSColor(red: 255/255.0, green: 165/255.0, blue: 0/255.0, alpha: 1) } // orange
            else if i == 16 { color = NSColor(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1) } // gold
            else if i == 17 { color = NSColor(red: 184/255.0, green: 134/255.0, blue: 11/255.0, alpha: 1) } // dark golden rod
            else if i == 18 { color = NSColor(red: 218/255.0, green: 165/255.0, blue: 32/255.0, alpha: 1) } // golden rod
            else if i == 19 { color = NSColor(red: 238/255.0, green: 232/255.0, blue: 170/255.0, alpha: 1) } // pale golden rod
                
                /* 20 - 29 */
            else if i == 20 { color = NSColor(red: 189/255.0, green: 183/255.0, blue: 107/255.0, alpha: 1) } // dark khaki
            else if i == 21 { color = NSColor(red: 240/255.0, green: 230/255.0, blue: 140/255.0, alpha: 1) } // khaki
            else if i == 22 { color = NSColor(red: 128/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1) } // olive
            else if i == 23 { color = NSColor(red: 255/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1) } // yellow
            else if i == 24 { color = NSColor(red: 154/255.0, green: 205/255.0, blue: 50/255.0, alpha: 1) } // yellow green
            else if i == 25 { color = NSColor(red: 85/255.0, green: 107/255.0, blue: 47/255.0, alpha: 1) } // dark olive green
            else if i == 26 { color = NSColor(red: 107/255.0, green: 142/255.0, blue: 35/255.0, alpha: 1) } // olive drab
            else if i == 27 { color = NSColor(red: 124/255.0, green: 252/255.0, blue: 0/255.0, alpha: 1) } // lawn green
            else if i == 28 { color = NSColor(red: 127/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1) } // chart reuse
            else if i == 29 { color = NSColor(red: 173/255.0, green: 255/255.0, blue: 47/255.0, alpha: 1) } // green yellow
                
                /* 30 - 39 */
            else if i == 30 { color = NSColor(red: 0/255.0, green: 100/255.0, blue: 0/255.0, alpha: 1) } // dark green
            else if i == 31 { color = NSColor(red: 0/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1) } // green
            else if i == 32 { color = NSColor(red: 34/255.0, green: 139/255.0, blue: 34/255.0, alpha: 1) } // forest green
            else if i == 33 { color = NSColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1) } // lime
            else if i == 34 { color = NSColor(red: 50/255.0, green: 205/255.0, blue: 50/255.0, alpha: 1) } // lime green
            else if i == 35 { color = NSColor(red: 144/255.0, green: 238/255.0, blue: 144/255.0, alpha: 1) } // light green
            else if i == 36 { color = NSColor(red: 152/255.0, green: 251/255.0, blue: 152/255.0, alpha: 1) } // pale green
            else if i == 37 { color = NSColor(red: 143/255.0, green: 188/255.0, blue: 143/255.0, alpha: 1) } // dark sea green
            else if i == 38 { color = NSColor(red: 0/255.0, green: 250/255.0, blue: 154/255.0, alpha: 1) } // medium spring green
            else if i == 39 { color = NSColor(red: 0/255.0, green: 255/255.0, blue: 127/255.0, alpha: 1) } // spring green
                
                /* 40 - 49 */
            else if i == 40 { color = NSColor(red: 46/255.0, green: 139/255.0, blue: 87/255.0, alpha: 1) } // sea green
            else if i == 41 { color = NSColor(red: 102/255.0, green: 205/255.0, blue: 170/255.0, alpha: 1) } // medium aqua marine
            else if i == 42 { color = NSColor(red: 60/255.0, green: 179/255.0, blue: 113/255.0, alpha: 1) } // medium sea green
            else if i == 43 { color = NSColor(red: 32/255.0, green: 178/255.0, blue: 170/255.0, alpha: 1) } // light sea green
            else if i == 44 { color = NSColor(red: 47/255.0, green: 79/255.0, blue: 79/255.0, alpha: 1) } // dark slate gray
            else if i == 45 { color = NSColor(red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1) } // teal
            else if i == 46 { color = NSColor(red: 0/255.0, green: 139/255.0, blue: 139/255.0, alpha: 1) } // dark cyan
            else if i == 47 { color = NSColor(red: 0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1) } // cyan
            else if i == 48 { color = NSColor(red: 224/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1) } // light cyan
            else if i == 49 { color = NSColor(red: 0/255.0, green: 206/255.0, blue: 209/255.0, alpha: 1) } // dark turquoise
                
                /* 50 - 59 */
            else if i == 50 { color = NSColor(red: 64/255.0, green: 224/255.0, blue: 208/255.0, alpha: 1) } // turquoise
            else if i == 51 { color = NSColor(red: 72/255.0, green: 209/255.0, blue: 204/255.0, alpha: 1) } // medium turquoise
            else if i == 52 { color = NSColor(red: 175/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1) } // pale turquoise
            else if i == 53 { color = NSColor(red: 127/255.0, green: 255/255.0, blue: 212/255.0, alpha: 1) } // aqua marine
            else if i == 54 { color = NSColor(red: 176/255.0, green: 224/255.0, blue: 230/255.0, alpha: 1) } // powder blue
            else if i == 55 { color = NSColor(red: 95/255.0, green: 158/255.0, blue: 160/255.0, alpha: 1) } // cadet blue
            else if i == 56 { color = NSColor(red: 70/255.0, green: 130/255.0, blue: 180/255.0, alpha: 1) } // steel blue
            else if i == 57 { color = NSColor(red: 100/255.0, green: 149/255.0, blue: 237/255.0, alpha: 1) } // corn flower blue
            else if i == 58 { color = NSColor(red: 0/255.0, green: 191/255.0, blue: 255/255.0, alpha: 1) } // deep sky blue
            else if i == 59 { color = NSColor(red: 30/255.0, green: 144/255.0, blue: 255/255.0, alpha: 1) } // dodger blue
                
                /* 60 - 69 */
            else if i == 60 { color = NSColor(red: 173/255.0, green: 216/255.0, blue: 230/255.0, alpha: 1) } // light blue
            else if i == 61 { color = NSColor(red: 135/255.0, green: 206/255.0, blue: 235/255.0, alpha: 1) } // sky blue
            else if i == 62 { color = NSColor(red: 135/255.0, green: 206/255.0, blue: 250/255.0, alpha: 1) } // light sky blue
            else if i == 63 { color = NSColor(red: 25/255.0, green: 25/255.0, blue: 112/255.0, alpha: 1) } // midnight blue
            else if i == 64 { color = NSColor(red: 0/255.0, green: 0/255.0, blue: 128/255.0, alpha: 1) } // navy
            else if i == 65 { color = NSColor(red: 0/255.0, green: 0/255.0, blue: 139/255.0, alpha: 1) } // dark blue
            else if i == 66 { color = NSColor(red: 0/255.0, green: 0/255.0, blue: 205/255.0, alpha: 1) } // medium blue
            else if i == 67 { color = NSColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1) } // blue
            else if i == 68 { color = NSColor(red: 65/255.0, green: 105/255.0, blue: 225/255.0, alpha: 1) } // royal blue
            else if i == 69 { color = NSColor(red: 138/255.0, green: 43/255.0, blue: 226/255.0, alpha: 1) } // blue violet
                
                /* 70 - 79 */
            else if i == 70 { color = NSColor(red: 75/255.0, green: 0/255.0, blue: 130/255.0, alpha: 1) } // indigo
            else if i == 71 { color = NSColor(red: 72/255.0, green: 61/255.0, blue: 139/255.0, alpha: 1) } // dark slate blue
            else if i == 72 { color = NSColor(red: 106/255.0, green: 90/255.0, blue: 205/255.0, alpha: 1) } // slate blue
            else if i == 73 { color = NSColor(red: 123/255.0, green: 104/255.0, blue: 238/255.0, alpha: 1) } // medium slate blue
            else if i == 74 { color = NSColor(red: 147/255.0, green: 112/255.0, blue: 219/255.0, alpha: 1) } // medium purple
            else if i == 75 { color = NSColor(red: 139/255.0, green: 0/255.0, blue: 139/255.0, alpha: 1) } // dark magenta
            else if i == 76 { color = NSColor(red: 148/255.0, green: 0/255.0, blue: 211/255.0, alpha: 1) } // dark violet
            else if i == 77 { color = NSColor(red: 153/255.0, green: 50/255.0, blue: 204/255.0, alpha: 1) } // dark orchid
            else if i == 78 { color = NSColor(red: 186/255.0, green: 85/255.0, blue: 211/255.0, alpha: 1) } // medium orchid
            else if i == 79 { color = NSColor(red: 128/255.0, green: 0/255.0, blue: 128/255.0, alpha: 1) } // purple
                
                /* 80 - 89 */
            else if i == 80 { color = NSColor(red: 216/255.0, green: 191/255.0, blue: 216/255.0, alpha: 1) } // thistle
            else if i == 81 { color = NSColor(red: 221/255.0, green: 160/255.0, blue: 221/255.0, alpha: 1) } // plum
            else if i == 82 { color = NSColor(red: 238/255.0, green: 130/255.0, blue: 238/255.0, alpha: 1) } // violet
            else if i == 83 { color = NSColor(red: 255/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1) } // magenta / fuchsia
            else if i == 84 { color = NSColor(red: 218/255.0, green: 112/255.0, blue: 214/255.0, alpha: 1) } // orchid
            else if i == 85 { color = NSColor(red: 199/255.0, green: 21/255.0, blue: 133/255.0, alpha: 1) } // medium violet red
            else if i == 86 { color = NSColor(red: 219/255.0, green: 112/255.0, blue: 147/255.0, alpha: 1) } // pale violet red
            else if i == 87 { color = NSColor(red: 255/255.0, green: 20/255.0, blue: 147/255.0, alpha: 1) } // deep pink
            else if i == 88 { color = NSColor(red: 255/255.0, green: 105/255.0, blue: 180/255.0, alpha: 1) } // hot pink
            else if i == 89 { color = NSColor(red: 255/255.0, green: 182/255.0, blue: 193/255.0, alpha: 1) } // light pink
                
                /* 90 - 99 */
            else if i == 90 { color = NSColor(red: 255/255.0, green: 192/255.0, blue: 203/255.0, alpha: 1) } // pink
            else if i == 91 { color = NSColor(red: 250/255.0, green: 235/255.0, blue: 215/255.0, alpha: 1) } // antique white
            else if i == 92 { color = NSColor(red: 245/255.0, green: 245/255.0, blue: 220/255.0, alpha: 1) } // beige
            else if i == 93 { color = NSColor(red: 255/255.0, green: 228/255.0, blue: 196/255.0, alpha: 1) } // bisque
            else if i == 94 { color = NSColor(red: 255/255.0, green: 235/255.0, blue: 205/255.0, alpha: 1) } // blanched almond
            else if i == 95 { color = NSColor(red: 245/255.0, green: 222/255.0, blue: 179/255.0, alpha: 1) } // wheat
            else if i == 96 { color = NSColor(red: 255/255.0, green: 248/255.0, blue: 220/255.0, alpha: 1) } // corn silk
            else if i == 97 { color = NSColor(red: 255/255.0, green: 250/255.0, blue: 205/255.0, alpha: 1) } // lemon chiffon
            else if i == 98 { color = NSColor(red: 250/255.0, green: 250/255.0, blue: 210/255.0, alpha: 1) } // light golden rod yellow
            else if i == 99 { color = NSColor(red: 255/255.0, green: 255/255.0, blue: 224/255.0, alpha: 1) } // light yellow
                
                /* 100 - 109 */
            else if i == 100 { color = NSColor(red: 139/255.0, green: 69/255.0, blue: 19/255.0, alpha: 1) } // saddle brown
            else if i == 101 { color = NSColor(red: 160/255.0, green: 82/255.0, blue: 45/255.0, alpha: 1) } // sienna
            else if i == 102 { color = NSColor(red: 210/255.0, green: 105/255.0, blue: 30/255.0, alpha: 1) } // chocolate
            else if i == 103 { color = NSColor(red: 205/255.0, green: 133/255.0, blue: 63/255.0, alpha: 1) } // peru
            else if i == 104 { color = NSColor(red: 244/255.0, green: 164/255.0, blue: 96/255.0, alpha: 1) } // sandy brown
            else if i == 105 { color = NSColor(red: 222/255.0, green: 184/255.0, blue: 135/255.0, alpha: 1) } // burly wood
            else if i == 106 { color = NSColor(red: 210/255.0, green: 180/255.0, blue: 140/255.0, alpha: 1) } // tan
            else if i == 107 { color = NSColor(red: 188/255.0, green: 143/255.0, blue: 143/255.0, alpha: 1) } // rosy brown
            else if i == 108 { color = NSColor(red: 255/255.0, green: 228/255.0, blue: 181/255.0, alpha: 1) } // moccasin
            else if i == 109 { color = NSColor(red: 255/255.0, green: 222/255.0, blue: 173/255.0, alpha: 1) } // navajo white
                
                /* 110 - 119 */
            else if i == 110 { color = NSColor(red: 255/255.0, green: 218/255.0, blue: 185/255.0, alpha: 1) } // peach puff
            else if i == 111 { color = NSColor(red: 255/255.0, green: 228/255.0, blue: 225/255.0, alpha: 1) } // misty rose
            else if i == 112 { color = NSColor(red: 255/255.0, green: 240/255.0, blue: 245/255.0, alpha: 1) } // lavender blush
            else if i == 113 { color = NSColor(red: 250/255.0, green: 240/255.0, blue: 230/255.0, alpha: 1) } // linen
            else if i == 114 { color = NSColor(red: 253/255.0, green: 245/255.0, blue: 230/255.0, alpha: 1) } // old lace
            else if i == 115 { color = NSColor(red: 255/255.0, green: 239/255.0, blue: 213/255.0, alpha: 1) } // papaya whip
            else if i == 116 { color = NSColor(red: 255/255.0, green: 245/255.0, blue: 238/255.0, alpha: 1) } // sea shell
            else if i == 117 { color = NSColor(red: 245/255.0, green: 255/255.0, blue: 250/255.0, alpha: 1) } // mint cream
            else if i == 118 { color = NSColor(red: 112/255.0, green: 128/255.0, blue: 144/255.0, alpha: 1) } // slate gray
            else if i == 119 { color = NSColor(red: 119/255.0, green: 136/255.0, blue: 153/255.0, alpha: 1) } // light slate gray
                
                /* 120 - 129 */
            else if i == 120 { color = NSColor(red: 176/255.0, green: 196/255.0, blue: 222/255.0, alpha: 1) } // light steel blue
            else if i == 121 { color = NSColor(red: 230/255.0, green: 230/255.0, blue: 250/255.0, alpha: 1) } // lavender
            else if i == 122 { color = NSColor(red: 255/255.0, green: 250/255.0, blue: 240/255.0, alpha: 1) } // floral white
            else if i == 123 { color = NSColor(red: 240/255.0, green: 248/255.0, blue: 255/255.0, alpha: 1) } // alice blue
            else if i == 124 { color = NSColor(red: 248/255.0, green: 248/255.0, blue: 255/255.0, alpha: 1) } // ghost white
            else if i == 125 { color = NSColor(red: 240/255.0, green: 255/255.0, blue: 240/255.0, alpha: 1) } // honeydew
            else if i == 126 { color = NSColor(red: 255/255.0, green: 255/255.0, blue: 240/255.0, alpha: 1) } // ivory
            else if i == 127 { color = NSColor(red: 240/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1) } // azure
            else if i == 128 { color = NSColor(red: 255/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1) } // snow
            else if i == 129 { color = NSColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1) } // black
                
                /* 130 - 139 */
            else if i == 130 { color = NSColor(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 1) } // dim gray / dim grey
            else if i == 131 { color = NSColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1) } // gray / grey
            else if i == 132 { color = NSColor(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1) } // dark gray / dark grey
            else if i == 133 { color = NSColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1) } // silver
            else if i == 134 { color = NSColor(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1) } // light gray / light grey
            else if i == 135 { color = NSColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1) } // gainsboro
            else if i == 136 { color = NSColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1) } // white smoke
            else if i == 137 { color = NSColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1) } // white
            let topImage = NSImage.makeColorImage(color: color, size: CGSize(width: 14.0, height: 8.0))
            let newImage = overImage(bottomImage: botImage, topImage: topImage, point: CGPoint(x: 1, y: 1))
            let menuItem = NSMenuItem(title: titleArray[i], action: nil, keyEquivalent: "")
            menuItem.image = newImage
            popupMenu.menu?.addItem(menuItem)
        }
    }
    
    func getPopupColor(index: Int) -> NSColor {
        if index == 0 { return NSColor.white }
        else if index == 1 { return NSColor.black }
        else if index == 2 { return NSColor.gray }
        else if index == 3 { return NSColor.blue }
        else if index == 4 { return NSColor.red }
        else if index == 5 { return NSColor.yellow }
        else if index == 6 { return NSColor.green }
        else if index == 7 { return NSColor.orange }
        else if index == 8 { return NSColor.cyan }
        else if index == 9 { return NSColor.brown }
        else if index == 10 { return NSColor.magenta }
        else { return NSColor.purple }
    }
    
    func getPopupColor2(index: Int) -> NSColor {
        if index == 0 { return NSColor.white }
        else if index == 1 { return NSColor.black }
        else if index == 2 { return NSColor.gray }
        else if index == 3 { return NSColor.blue }
        else if index == 4 { return NSColor.red }
        else if index == 5 { return NSColor.yellow }
        else if index == 6 { return NSColor.green }
        else if index == 7 { return NSColor.orange }
        else if index == 8 { return NSColor.cyan }
        else if index == 9 { return NSColor.brown }
        else if index == 10 { return NSColor.magenta }
        else if index == 11 { return NSColor.purple }
            
        else if index == 12 { return NSColor(red: 128/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1) }
        else if index == 13 { return NSColor(red: 220/255.0, green: 20/255.0, blue: 60/255.0, alpha: 1) }
        else if index == 14 { return NSColor(red: 255/255.0, green: 99/255.0, blue: 71/255.0, alpha: 1) }
        else if index == 15 { return NSColor(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1) }
        else if index == 16 { return NSColor(red: 218/255.0, green: 165/255.0, blue: 32/255.0, alpha: 1) }
        else if index == 17 { return NSColor(red: 240/255.0, green: 230/255.0, blue: 140/255.0, alpha: 1) }
        else if index == 18 { return NSColor(red: 128/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1) }
        else if index == 19 { return NSColor(red: 154/255.0, green: 205/255.0, blue: 50/255.0, alpha: 1) }
        else if index == 20 { return NSColor(red: 124/255.0, green: 252/255.0, blue: 0/255.0, alpha: 1) }
        else if index == 21 { return NSColor(red: 34/255.0, green: 139/255.0, blue: 34/255.0, alpha: 1) }
        else if index == 22 { return NSColor(red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1) }
            
        else if index == 23 { return NSColor(red: 64/255.0, green: 224/255.0, blue: 208/255.0, alpha: 1) }
        else if index == 24 { return NSColor(red: 70/255.0, green: 130/255.0, blue: 180/255.0, alpha: 1) }
        else if index == 25 { return NSColor(red: 0/255.0, green: 191/255.0, blue: 255/255.0, alpha: 1) }
        else if index == 26 { return NSColor(red: 0/255.0, green: 0/255.0, blue: 128/255.0, alpha: 1) }
        else if index == 27 { return NSColor(red: 75/255.0, green: 0/255.0, blue: 130/255.0, alpha: 1) }
        else if index == 28 { return NSColor(red: 221/255.0, green: 160/255.0, blue: 221/255.0, alpha: 1) }
        else if index == 29 { return NSColor(red: 255/255.0, green: 192/255.0, blue: 203/255.0, alpha: 1) }
        else if index == 30 { return NSColor(red: 245/255.0, green: 245/255.0, blue: 220/255.0, alpha: 1) }
        else if index == 31 { return NSColor(red: 210/255.0, green: 105/255.0, blue: 30/255.0, alpha: 1) }
        else if index == 32 { return NSColor(red: 255/255.0, green: 255/255.0, blue: 240/255.0, alpha: 1) }
        else if index == 33 { return NSColor(red: 240/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1) }
        else if index == 34 { return NSColor(red: 255/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1) }
        else { return NSColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1) }
    }
    
    func getPopupColor3(index: Int) -> NSColor {
        if index == 0 { return NSColor.white }
        else if index == 1 { return NSColor.black }
        else if index == 2 { return NSColor.gray }
        else if index == 3 { return NSColor.blue }
        else if index == 4 { return NSColor.red }
        else if index == 5 { return NSColor.yellow }
        else if index == 6 { return NSColor.green }
        else if index == 7 { return NSColor.orange }
        else if index == 8 { return NSColor.cyan }
        else if index == 9 { return NSColor.brown }
        else if index == 10 { return NSColor.magenta }
        else if index == 11 { return NSColor.purple }
            
        else if index == 12 { return NSColor(red: 128/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1) } // Maroon
        else if index == 13 { return NSColor(red: 220/255.0, green: 20/255.0, blue: 60/255.0, alpha: 1) } // Crimson
        else if index == 14 { return NSColor(red: 255/255.0, green: 99/255.0, blue: 71/255.0, alpha: 1) } // Tomato
        else if index == 15 { return NSColor(red: 255/255.0, green: 127/255.0, blue: 80/255.0, alpha: 1) } // Coral
        else if index == 16 { return NSColor(red: 250/255.0, green: 128/255.0, blue: 114/255.0, alpha: 1) } // Salmon
        else if index == 17 { return NSColor(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1) } // Gold
        else if index == 18 { return NSColor(red: 218/255.0, green: 165/255.0, blue: 32/255.0, alpha: 1) } // Golden rod
        else if index == 19 { return NSColor(red: 240/255.0, green: 230/255.0, blue: 140/255.0, alpha: 1) } // Khaki
            
        else if index == 20 { return NSColor(red: 128/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1) } // Olive
        else if index == 21 { return NSColor(red: 154/255.0, green: 205/255.0, blue: 50/255.0, alpha: 1) } // Yellow green
        else if index == 22 { return NSColor(red: 124/255.0, green: 252/255.0, blue: 0/255.0, alpha: 1) } // Lawn green
        else if index == 23 { return NSColor(red: 173/255.0, green: 255/255.0, blue: 47/255.0, alpha: 1) } // Green yellow
        else if index == 24 { return NSColor(red: 0/255.0, green: 100/255.0, blue: 0/255.0, alpha: 1) } // Dark green
        else if index == 25 { return NSColor(red: 0/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1) } // Green
        else if index == 26 { return NSColor(red: 34/255.0, green: 139/255.0, blue: 34/255.0, alpha: 1) } // Forest green
        else if index == 27 { return NSColor(red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1) } // Teal
        else if index == 28 { return NSColor(red: 0/255.0, green: 139/255.0, blue: 139/255.0, alpha: 1) } // Dark cyan
        else if index == 29 { return NSColor(red: 224/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1) } // Light cyan
            
        else if index == 30 { return NSColor(red: 64/255.0, green: 224/255.0, blue: 208/255.0, alpha: 1) } // Turquoise
        else if index == 31 { return NSColor(red: 70/255.0, green: 130/255.0, blue: 180/255.0, alpha: 1) } // Steel blue
        else if index == 32 { return NSColor(red: 0/255.0, green: 191/255.0, blue: 255/255.0, alpha: 1) } // Deep sky blue
        else if index == 33 { return NSColor(red: 173/255.0, green: 216/255.0, blue: 230/255.0, alpha: 1) } // Light blue
        else if index == 34 { return NSColor(red: 135/255.0, green: 206/255.0, blue: 235/255.0, alpha: 1) } // Sky blue
        else if index == 35 { return NSColor(red: 0/255.0, green: 0/255.0, blue: 128/255.0, alpha: 1) } // Navy
        else if index == 36 { return NSColor(red: 65/255.0, green: 105/255.0, blue: 225/255.0, alpha: 1) } // Royal blue
        else if index == 37 { return NSColor(red: 138/255.0, green: 43/255.0, blue: 226/255.0, alpha: 1) } // Blue violet
        else if index == 38 { return NSColor(red: 75/255.0, green: 0/255.0, blue: 130/255.0, alpha: 1) } // Indigo
        else if index == 39 { return NSColor(red: 216/255.0, green: 191/255.0, blue: 216/255.0, alpha: 1) } // Thistle
            
        else if index == 40 { return NSColor(red: 221/255.0, green: 160/255.0, blue: 221/255.0, alpha: 1) } // Plum
        else if index == 41 { return NSColor(red: 238/255.0, green: 130/255.0, blue: 238/255.0, alpha: 1) } // Violet
        else if index == 42 { return NSColor(red: 218/255.0, green: 112/255.0, blue: 214/255.0, alpha: 1) } // Orchid
        else if index == 43 { return NSColor(red: 255/255.0, green: 20/255.0, blue: 147/255.0, alpha: 1) } // Deep pink
        else if index == 44 { return NSColor(red: 255/255.0, green: 105/255.0, blue: 180/255.0, alpha: 1) } // Hot pink
        else if index == 45 { return NSColor(red: 255/255.0, green: 182/255.0, blue: 193/255.0, alpha: 1) } // Light pink
        else if index == 46 { return NSColor(red: 255/255.0, green: 192/255.0, blue: 203/255.0, alpha: 1) } // Pink
        else if index == 47 { return NSColor(red: 250/255.0, green: 235/255.0, blue: 215/255.0, alpha: 1) } // Antique white
        else if index == 48 { return NSColor(red: 245/255.0, green: 245/255.0, blue: 220/255.0, alpha: 1) } // Beige
        else if index == 49 { return NSColor(red: 255/255.0, green: 228/255.0, blue: 196/255.0, alpha: 1) } // Bisque
            
        else if index == 50 { return NSColor(red: 245/255.0, green: 222/255.0, blue: 179/255.0, alpha: 1) } // Wheat
        else if index == 51 { return NSColor(red: 255/255.0, green: 248/255.0, blue: 220/255.0, alpha: 1) } // Corn silk
        else if index == 52 { return NSColor(red: 160/255.0, green: 82/255.0, blue: 45/255.0, alpha: 1) } // Sienna
        else if index == 53 { return NSColor(red: 210/255.0, green: 105/255.0, blue: 30/255.0, alpha: 1) } // Chocolate
        else if index == 54 { return NSColor(red: 210/255.0, green: 180/255.0, blue: 140/255.0, alpha: 1) } // Tan
        else if index == 55 { return NSColor(red: 255/255.0, green: 228/255.0, blue: 181/255.0, alpha: 1) } // Moccasin
        else if index == 56 { return NSColor(red: 250/255.0, green: 240/255.0, blue: 230/255.0, alpha: 1) } // Linen
        else if index == 57 { return NSColor(red: 255/255.0, green: 245/255.0, blue: 238/255.0, alpha: 1) } // Sea shell
        else if index == 58 { return NSColor(red: 245/255.0, green: 255/255.0, blue: 250/255.0, alpha: 1) } // Mint cream
        else if index == 59 { return NSColor(red: 230/255.0, green: 230/255.0, blue: 250/255.0, alpha: 1) } // Lavender
            
        else if index == 60 { return NSColor(red: 255/255.0, green: 250/255.0, blue: 240/255.0, alpha: 1) } // Floral white
        else if index == 61 { return NSColor(red: 248/255.0, green: 248/255.0, blue: 255/255.0, alpha: 1) } // Ghost white
        else if index == 62 { return NSColor(red: 240/255.0, green: 255/255.0, blue: 240/255.0, alpha: 1) } // Honeydew
        else if index == 63 { return NSColor(red: 255/255.0, green: 255/255.0, blue: 240/255.0, alpha: 1) } // Ivory
        else if index == 64 { return NSColor(red: 240/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1) } // Azure
        else if index == 65 { return NSColor(red: 255/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1) } // Snow
        else if index == 66 { return NSColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1) } // Silver
        else if index == 67 { return NSColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1) } // Gainsboro
        else if index == 68 { return NSColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1) } // White smoke
        else { return NSColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1) }
    }
    
    func getPopupColor4(index: Int) -> NSColor {
        if index == 0 { return NSColor(red: 128/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1) } // maroon
        else if index == 1 { return NSColor(red: 139/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1) } // dark red
        else if index == 2 { return NSColor(red: 165/255.0, green: 42/255.0, blue: 42/255.0, alpha: 1) } // brown
        else if index == 3 { return NSColor(red: 178/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1) } // firebrick
        else if index == 4 { return NSColor(red: 220/255.0, green: 20/255.0, blue: 60/255.0, alpha: 1) } // crimson
        else if index == 5 { return NSColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1) } // red
        else if index == 6 { return NSColor(red: 255/255.0, green: 99/255.0, blue: 71/255.0, alpha: 1) } // tomato
        else if index == 7 { return NSColor(red: 255/255.0, green: 127/255.0, blue: 80/255.0, alpha: 1) } // coral
        else if index == 8 { return NSColor(red: 205/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1) } // indian red
        else if index == 9 { return NSColor(red: 240/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1) } // light coral
            
            /* 10 - 19 */
        else if index == 10 { return NSColor(red: 233/255.0, green: 150/255.0, blue: 122/255.0, alpha: 1) } // dark salmon
        else if index == 11 { return NSColor(red: 250/255.0, green: 128/255.0, blue: 114/255.0, alpha: 1) } // salmon
        else if index == 12 { return NSColor(red: 255/255.0, green: 160/255.0, blue: 122/255.0, alpha: 1) } // light salmon
        else if index == 13 { return NSColor(red: 255/255.0, green: 69/255.0, blue: 0/255.0, alpha: 1) } // orange red
        else if index == 14 { return NSColor(red: 255/255.0, green: 140/255.0, blue: 0/255.0, alpha: 1) } // dark orange
        else if index == 15 { return NSColor(red: 255/255.0, green: 165/255.0, blue: 0/255.0, alpha: 1) } // orange
        else if index == 16 { return NSColor(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1) } // gold
        else if index == 17 { return NSColor(red: 184/255.0, green: 134/255.0, blue: 11/255.0, alpha: 1) } // dark golden rod
        else if index == 18 { return NSColor(red: 218/255.0, green: 165/255.0, blue: 32/255.0, alpha: 1) } // golden rod
        else if index == 19 { return NSColor(red: 238/255.0, green: 232/255.0, blue: 170/255.0, alpha: 1) } // pale golden rod
            
            /* 20 - 29 */
        else if index == 20 { return NSColor(red: 189/255.0, green: 183/255.0, blue: 107/255.0, alpha: 1) } // dark khaki
        else if index == 21 { return NSColor(red: 240/255.0, green: 230/255.0, blue: 140/255.0, alpha: 1) } // khaki
        else if index == 22 { return NSColor(red: 128/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1) } // olive
        else if index == 23 { return NSColor(red: 255/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1) } // yellow
        else if index == 24 { return NSColor(red: 154/255.0, green: 205/255.0, blue: 50/255.0, alpha: 1) } // yellow green
        else if index == 25 { return NSColor(red: 85/255.0, green: 107/255.0, blue: 47/255.0, alpha: 1) } // dark olive green
        else if index == 26 { return NSColor(red: 107/255.0, green: 142/255.0, blue: 35/255.0, alpha: 1) } // olive drab
        else if index == 27 { return NSColor(red: 124/255.0, green: 252/255.0, blue: 0/255.0, alpha: 1) } // lawn green
        else if index == 28 { return NSColor(red: 127/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1) } // chart reuse
        else if index == 29 { return NSColor(red: 173/255.0, green: 255/255.0, blue: 47/255.0, alpha: 1) } // green yellow
            
            /* 30 - 39 */
        else if index == 30 { return NSColor(red: 0/255.0, green: 100, blue: 0/255.0, alpha: 1) } // dark green
        else if index == 31 { return NSColor(red: 0/255.0, green: 128, blue: 0/255.0, alpha: 1) } // green
        else if index == 32 { return NSColor(red: 34/255.0, green: 139/255.0, blue: 34/255.0, alpha: 1) } // forest green
        else if index == 33 { return NSColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1) } // lime
        else if index == 34 { return NSColor(red: 50/255.0, green: 205/255.0, blue: 50/255.0, alpha: 1) } // lime green
        else if index == 35 { return NSColor(red: 144/255.0, green: 238/255.0, blue: 144/255.0, alpha: 1) } // light green
        else if index == 36 { return NSColor(red: 152/255.0, green: 251/255.0, blue: 152/255.0, alpha: 1) } // pale green
        else if index == 37 { return NSColor(red: 143/255.0, green: 188/255.0, blue: 143/255.0, alpha: 1) } // dark sea green
        else if index == 38 { return NSColor(red: 0/255.0, green: 250/255.0, blue: 154/255.0, alpha: 1) } // medium spring green
        else if index == 39 { return NSColor(red: 0/255.0, green: 255/255.0, blue: 127/255.0, alpha: 1) } // spring green
            
            /* 40 - 49 */
        else if index == 40 { return NSColor(red: 46/255.0, green: 139/255.0, blue: 87/255.0, alpha: 1) } // sea green
        else if index == 41 { return NSColor(red: 102/255.0, green: 205/255.0, blue: 170/255.0, alpha: 1) } // medium aqua marine
        else if index == 42 { return NSColor(red: 60/255.0, green: 179/255.0, blue: 113/255.0, alpha: 1) } // medium sea green
        else if index == 43 { return NSColor(red: 32/255.0, green: 178/255.0, blue: 170/255.0, alpha: 1) } // light sea green
        else if index == 44 { return NSColor(red: 47/255.0, green: 79/255.0, blue: 79/255.0, alpha: 1) } // dark slate gray
        else if index == 45 { return NSColor(red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1) } // teal
        else if index == 46 { return NSColor(red: 0/255.0, green: 139/255.0, blue: 139/255.0, alpha: 1) } // dark cyan
        else if index == 47 { return NSColor(red: 0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1) } // cyan
        else if index == 48 { return NSColor(red: 224/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1) } // light cyan
        else if index == 49 { return NSColor(red: 0/255.0, green: 206/255.0, blue: 209/255.0, alpha: 1) } // dark turquoise
            
            /* 50 - 59 */
        else if index == 50 { return NSColor(red: 64/255.0, green: 224/255.0, blue: 208/255.0, alpha: 1) } // turquoise
        else if index == 51 { return NSColor(red: 72/255.0, green: 209/255.0, blue: 204/255.0, alpha: 1) } // medium turquoise
        else if index == 52 { return NSColor(red: 175/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1) } // pale turquoise
        else if index == 53 { return NSColor(red: 127/255.0, green: 255/255.0, blue: 212/255.0, alpha: 1) } // aqua marine
        else if index == 54 { return NSColor(red: 176/255.0, green: 224/255.0, blue: 230/255.0, alpha: 1) } // powder blue
        else if index == 55 { return NSColor(red: 95/255.0, green: 158/255.0, blue: 160/255.0, alpha: 1) } // cadet blue
        else if index == 56 { return NSColor(red: 70/255.0, green: 130/255.0, blue: 180/255.0, alpha: 1) } // steel blue
        else if index == 57 { return NSColor(red: 100/255.0, green: 149/255.0, blue: 237/255.0, alpha: 1) } // corn flower blue
        else if index == 58 { return NSColor(red: 0/255.0, green: 191/255.0, blue: 255/255.0, alpha: 1) } // deep sky blue
        else if index == 59 { return NSColor(red: 30/255.0, green: 144/255.0, blue: 255/255.0, alpha: 1) } // dodger blue
            
            /* 60 - 69 */
        else if index == 60 { return NSColor(red: 173/255.0, green: 216/255.0, blue: 230/255.0, alpha: 1) } // light blue
        else if index == 61 { return NSColor(red: 135/255.0, green: 206/255.0, blue: 235/255.0, alpha: 1) } // sky blue
        else if index == 62 { return NSColor(red: 135/255.0, green: 206/255.0, blue: 250/255.0, alpha: 1) } // light sky blue
        else if index == 63 { return NSColor(red: 25/255.0, green: 25/255.0, blue: 112/255.0, alpha: 1) } // midnight blue
        else if index == 64 { return NSColor(red: 0/255.0, green: 0/255.0, blue: 128/255.0, alpha: 1) } // navy
        else if index == 65 { return NSColor(red: 0/255.0, green: 0/255.0, blue: 139/255.0, alpha: 1) } // dark blue
        else if index == 66 { return NSColor(red: 0/255.0, green: 0/255.0, blue: 205/255.0, alpha: 1) } // medium blue
        else if index == 67 { return NSColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1) } // blue
        else if index == 68 { return NSColor(red: 65/255.0, green: 105/255.0, blue: 225/255.0, alpha: 1) } // royal blue
        else if index == 69 { return NSColor(red: 138/255.0, green: 43/255.0, blue: 226/255.0, alpha: 1) } // blue violet
            
            /* 70 - 79 */
        else if index == 70 { return NSColor(red: 75/255.0, green: 0/255.0, blue: 130/255.0, alpha: 1) } // indigo
        else if index == 71 { return NSColor(red: 72/255.0, green: 61/255.0, blue: 139/255.0, alpha: 1) } // dark slate blue
        else if index == 72 { return NSColor(red: 106/255.0, green: 90/255.0, blue: 205/255.0, alpha: 1) } // slate blue
        else if index == 73 { return NSColor(red: 123/255.0, green: 104/255.0, blue: 238/255.0, alpha: 1) } // medium slate blue
        else if index == 74 { return NSColor(red: 147/255.0, green: 112/255.0, blue: 219/255.0, alpha: 1) } // medium purple
        else if index == 75 { return NSColor(red: 139/255.0, green: 0/255.0, blue: 139/255.0, alpha: 1) } // dark magenta
        else if index == 76 { return NSColor(red: 148/255.0, green: 0/255.0, blue: 211/255.0, alpha: 1) } // dark violet
        else if index == 77 { return NSColor(red: 153/255.0, green: 50/255.0, blue: 204/255.0, alpha: 1) } // dark orchid
        else if index == 78 { return NSColor(red: 186/255.0, green: 85/255.0, blue: 211/255.0, alpha: 1) } // medium orchid
        else if index == 79 { return NSColor(red: 128/255.0, green: 0/255.0, blue: 128/255.0, alpha: 1) } // purple
            
            /* 80 - 89 */
        else if index == 80 { return NSColor(red: 216/255.0, green: 191/255.0, blue: 216/255.0, alpha: 1) } // thistle
        else if index == 81 { return NSColor(red: 221/255.0, green: 160/255.0, blue: 221/255.0, alpha: 1) } // plum
        else if index == 82 { return NSColor(red: 238/255.0, green: 130/255.0, blue: 238/255.0, alpha: 1) } // violet
        else if index == 83 { return NSColor(red: 255/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1) } // magenta / fuchsia
        else if index == 84 { return NSColor(red: 218/255.0, green: 112/255.0, blue: 214/255.0, alpha: 1) } // orchid
        else if index == 85 { return NSColor(red: 199/255.0, green: 21/255.0, blue: 133/255.0, alpha: 1) } // medium violet red
        else if index == 86 { return NSColor(red: 219/255.0, green: 112/255.0, blue: 147/255.0, alpha: 1) } // pale violet red
        else if index == 87 { return NSColor(red: 255/255.0, green: 20/255.0, blue: 147/255.0, alpha: 1) } // deep pink
        else if index == 88 { return NSColor(red: 255/255.0, green: 105/255.0, blue: 180/255.0, alpha: 1) } // hot pink
        else if index == 89 { return NSColor(red: 255/255.0, green: 182/255.0, blue: 193/255.0, alpha: 1) } // light pink
            
            /* 90 - 99 */
        else if index == 90 { return NSColor(red: 255/255.0, green: 192/255.0, blue: 203/255.0, alpha: 1) } // pink
        else if index == 91 { return NSColor(red: 250/255.0, green: 235/255.0, blue: 215/255.0, alpha: 1) } // antique white
        else if index == 92 { return NSColor(red: 245/255.0, green: 245/255.0, blue: 220/255.0, alpha: 1) } // beige
        else if index == 93 { return NSColor(red: 255/255.0, green: 228/255.0, blue: 196/255.0, alpha: 1) } // bisque
        else if index == 94 { return NSColor(red: 255/255.0, green: 235/255.0, blue: 205/255.0, alpha: 1) } // blanched almond
        else if index == 95 { return NSColor(red: 245/255.0, green: 222/255.0, blue: 179/255.0, alpha: 1) } // wheat
        else if index == 96 { return NSColor(red: 255/255.0, green: 248/255.0, blue: 220/255.0, alpha: 1) } // corn silk
        else if index == 97 { return NSColor(red: 255/255.0, green: 250/255.0, blue: 205/255.0, alpha: 1) } // lemon chiffon
        else if index == 98 { return NSColor(red: 250/255.0, green: 250/255.0, blue: 210/255.0, alpha: 1) } // light golden rod yellow
        else if index == 99 { return NSColor(red: 255/255.0, green: 255/255.0, blue: 224/255.0, alpha: 1) } // light yellow
            
            /* 100 - 109 */
        else if index == 100 { return NSColor(red: 139/255.0, green: 69/255.0, blue: 19/255.0, alpha: 1) } // saddle brown
        else if index == 101 { return NSColor(red: 160/255.0, green: 82/255.0, blue: 45/255.0, alpha: 1) } // sienna
        else if index == 102 { return NSColor(red: 210/255.0, green: 105/255.0, blue: 30/255.0, alpha: 1) } // chocolate
        else if index == 103 { return NSColor(red: 205/255.0, green: 133/255.0, blue: 63/255.0, alpha: 1) } // peru
        else if index == 104 { return NSColor(red: 244/255.0, green: 164/255.0, blue: 96/255.0, alpha: 1) } // sandy brown
        else if index == 105 { return NSColor(red: 222/255.0, green: 184/255.0, blue: 135/255.0, alpha: 1) } // burly wood
        else if index == 106 { return NSColor(red: 210/255.0, green: 180/255.0, blue: 140/255.0, alpha: 1) } // tan
        else if index == 107 { return NSColor(red: 188/255.0, green: 143/255.0, blue: 143/255.0, alpha: 1) } // rosy brown
        else if index == 108 { return NSColor(red: 255/255.0, green: 228/255.0, blue: 181/255.0, alpha: 1) } // moccasin
        else if index == 109 { return NSColor(red: 255/255.0, green: 222/255.0, blue: 173/255.0, alpha: 1) } // navajo white
            
            /* 110 - 119 */
        else if index == 110 { return NSColor(red: 255/255.0, green: 218/255.0, blue: 185/255.0, alpha: 1) } // peach puff
        else if index == 111 { return NSColor(red: 255/255.0, green: 228/255.0, blue: 225/255.0, alpha: 1) } // misty rose
        else if index == 112 { return NSColor(red: 255/255.0, green: 240/255.0, blue: 245/255.0, alpha: 1) } // lavender blush
        else if index == 113 { return NSColor(red: 250/255.0, green: 240/255.0, blue: 230/255.0, alpha: 1) } // linen
        else if index == 114 { return NSColor(red: 253/255.0, green: 245/255.0, blue: 230/255.0, alpha: 1) } // old lace
        else if index == 115 { return NSColor(red: 255/255.0, green: 239/255.0, blue: 213/255.0, alpha: 1) } // papaya whip
        else if index == 116 { return NSColor(red: 255/255.0, green: 245/255.0, blue: 238/255.0, alpha: 1) } // sea shell
        else if index == 117 { return NSColor(red: 245/255.0, green: 255/255.0, blue: 250/255.0, alpha: 1) } // mint cream
        else if index == 118 { return NSColor(red: 112/255.0, green: 128/255.0, blue: 144/255.0, alpha: 1) } // slate gray
        else if index == 119 { return NSColor(red: 119/255.0, green: 136/255.0, blue: 153/255.0, alpha: 1) } // light slate gray
            
            /* 120 - 129 */
        else if index == 120 { return NSColor(red: 176/255.0, green: 196/255.0, blue: 222/255.0, alpha: 1) } // light steel blue
        else if index == 121 { return NSColor(red: 230/255.0, green: 230/255.0, blue: 250/255.0, alpha: 1) } // lavender
        else if index == 122 { return NSColor(red: 255/255.0, green: 250/255.0, blue: 240/255.0, alpha: 1) } // floral white
        else if index == 123 { return NSColor(red: 240/255.0, green: 248/255.0, blue: 255/255.0, alpha: 1) } // alice blue
        else if index == 124 { return NSColor(red: 248/255.0, green: 248/255.0, blue: 255/255.0, alpha: 1) } // ghost white
        else if index == 125 { return NSColor(red: 240/255.0, green: 255/255.0, blue: 240/255.0, alpha: 1) } // honeydew
        else if index == 126 { return NSColor(red: 255/255.0, green: 255/255.0, blue: 240/255.0, alpha: 1) } // ivory
        else if index == 127 { return NSColor(red: 240/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1) } // azure
        else if index == 128 { return NSColor(red: 255/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1) } // snow
        else if index == 129 { return NSColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1) } // black
            
            /* 130 - 139 */
        else if index == 130 { return NSColor(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 1) } // dim gray / dim grey
        else if index == 131 { return NSColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1) } // gray / grey
        else if index == 132 { return NSColor(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1) } // dark gray / dark grey
        else if index == 133 { return NSColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1) } // silver
        else if index == 134 { return NSColor(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1) } // light gray / light grey
        else if index == 135 { return NSColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1) } // gainsboro
        else if index == 136 { return NSColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1) } // white smoke
        else { return NSColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1) } // white
    }
    
    func getWinFactor() -> CGFloat? {
        if let view = self.view.window {
            // do not use it with viewDidLoad //
            let factor = view.backingScaleFactor
            return factor
        } else {
            return nil
        }
    }
        
    func isICloudContainerAvailable() -> Bool {
        if FileManager.default.ubiquityIdentityToken != nil {
            //print("iCloud Available")
            return true
        } else {
            //print("iCloud Unavailable")
            return false
        }
    }
}

