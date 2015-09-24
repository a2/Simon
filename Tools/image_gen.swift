#!/usr/bin/env xcrun swift

import AppKit

func rgb(r: Int, _ g: Int, _ b: Int) -> NSColor {
    return NSColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
}

extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.init(origin: origin, size: size)
    }
}

enum Color: String {
    case Red
    case Green
    case Yellow
    case Blue

    var color: NSColor {
        switch self {
        case .Red:
            return rgb(255, 105, 97)
        case .Green:
            return rgb(119, 221, 119)
        case .Yellow:
            return rgb(214, 214, 127)
        case .Blue:
            return rgb(119, 158, 203)
        }
    }

    func center(dimension: CGFloat) -> CGPoint {
        switch self {
        case .Red:
            return CGPoint(x: 0, y: 0)
        case .Green:
            return CGPoint(x: dimension, y: 0)
        case .Yellow:
            return CGPoint(x: dimension, y: dimension)
        case .Blue:
            return CGPoint(x: 0, y: dimension)
        }
    }

    func bitmapImage(dimension dimension: CGFloat, percentHighlighted: CGFloat = 0) -> NSBitmapImageRep {
        let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(dimension), pixelsHigh: Int(dimension), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSDeviceRGBColorSpace, bytesPerRow: 0, bitsPerPixel: 0)!

        let graphicsContext = NSGraphicsContext(bitmapImageRep: bitmap)!
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.setCurrentContext(graphicsContext)

        let ctx = graphicsContext.CGContext

        let centerPoint = center(dimension)
        let roundedDimension = 2 * dimension
        let roundedRect = CGRect(center: centerPoint, size: CGSize(width: roundedDimension, height: roundedDimension))
        let roundedPath = CGPathCreateWithRoundedRect(roundedRect, dimension, dimension, nil)
        CGContextAddPath(ctx, roundedPath)
        CGContextClip(ctx)

        CGContextSetFillColorWithColor(ctx, color.CGColor)
        CGContextFillRect(ctx, CGRect(x: 0, y: 0, width: dimension, height: dimension))

        if percentHighlighted > 0 {
            let colors = [NSColor(white: 1, alpha: percentHighlighted).CGColor, NSColor(white: 1, alpha: 0).CGColor]
            let gradient = CGGradientCreateWithColors(nil, colors, nil)
            let outerRadius = dimension / 2 + dimension * 2 * percentHighlighted
            CGContextDrawRadialGradient(ctx, gradient, centerPoint, 0.5, centerPoint, outerRadius + dimension, [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
        }

        NSGraphicsContext.restoreGraphicsState()

        return bitmap
    }
}

let colors: [Color] = [.Red, .Green, .Yellow, .Blue]
let sizes: [String : CGFloat] = ["small": 132, "large": 152, "unspecified": 152]
let styles: [Int : CGFloat] = [1: 1, 2: 0.9, 3: 0.8, 4: 0.7, 5: 0.6, 6: 0.5, 7: 0.4, 8: 0.3, 9: 0.2, 10: 0.1, 11: 0]

@noreturn func printUsage() {
    let this = (Process.arguments[0] as NSString).lastPathComponent
    print("Usage: \(this) [output]")
    exit(1)
}

guard Process.argc > 1 else { printUsage() }

let executableURL = NSURL.fileURLWithFileSystemRepresentation(Process.unsafeArgv[0], isDirectory: false, relativeToURL: nil)
let outputURL = NSURL.fileURLWithFileSystemRepresentation(Process.unsafeArgv[1], isDirectory: false, relativeToURL: nil)
let contentsFolderJSON = executableURL.URLByDeletingLastPathComponent!.URLByAppendingPathComponent("Contents~folder.json")
let contentsImagesetJSON = executableURL.URLByDeletingLastPathComponent!.URLByAppendingPathComponent("Contents~imageset.json")
let fileManager = NSFileManager.defaultManager()

for color in colors {
    let folderDirectory = outputURL.URLByAppendingPathComponent(color.rawValue)
    _ = try? fileManager.createDirectoryAtURL(folderDirectory, withIntermediateDirectories: true, attributes: nil)
    _ = try? fileManager.copyItemAtURL(contentsFolderJSON, toURL: folderDirectory.URLByAppendingPathComponent("Contents.json"))

    for (styleName, percentHighlighted) in styles {
        let imagesetDirectory = folderDirectory.URLByAppendingPathComponent("\(color.rawValue)\(styleName).imageset")
        _ = try? fileManager.createDirectoryAtURL(imagesetDirectory, withIntermediateDirectories: true, attributes: nil)
        _ = try? fileManager.copyItemAtURL(contentsImagesetJSON, toURL: imagesetDirectory.URLByAppendingPathComponent("Contents.json"))

        for (sizeName, dimension) in sizes {
            let data = color
                .bitmapImage(dimension: dimension, percentHighlighted: percentHighlighted)
                .representationUsingType(.NSPNGFileType, properties: [:])!

            do {
                try data.writeToURL(imagesetDirectory.URLByAppendingPathComponent("\(sizeName).png"), options: .DataWritingAtomic)
            } catch {
                print("Could not write \(color.rawValue)\(styleName).imageset/\(styleName).png: \(error)")
                exit(1)
            }
        }
    }
}
