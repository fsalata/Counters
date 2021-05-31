//
//  UIImage+Badge.swift
//  Counters
//
//

import UIKit

internal extension UIImage {
    private enum Constants {
        static let size = CGSize(width: 49, height: 49)
        static let cornerRadius: CGFloat = 10
        static let pointSize: CGFloat = 22
        static let lineWidth: CGFloat = 1
        static let strokeColor = UIColor(white: 0, alpha: 0.05).cgColor
    }
    
    static func badge(sytemIcon: String, color: UIColor?) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(Constants.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let rect = CGRect(origin: .zero, size: Constants.size)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: Constants.cornerRadius)
        context.addPath(path.cgPath)
        context.setStrokeColor(Constants.strokeColor)
        if let color = color {
            context.setFillColor(color.cgColor)
        }
        context.setLineWidth(Constants.lineWidth)
        context.drawPath(using: .fillStroke)
        let config = UIImage.SymbolConfiguration(pointSize: Constants.pointSize,
                                                 weight: .semibold)
        if let image = UIImage(systemName: sytemIcon, withConfiguration: config) {
            let x = (Constants.size.width - image.size.width)/2.0
            let y = (Constants.size.height - image.size.height)/2.0
            let point = CGPoint(x: x, y: y)
            image.draw(at: point, blendMode: .destinationOut, alpha: 1)
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
