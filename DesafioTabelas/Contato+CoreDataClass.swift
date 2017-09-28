//
//  Contato+CoreDataClass.swift
//  DesafioTabelas
//

import Foundation
import CoreData
import UIKit

@objc(Contato)
public class Contato: NSManagedObject {
    
    public func imageAsMedia(image: UIImage) {
        self.foto = NSData(data: UIImageJPEGRepresentation(image, 0.9)!)
    }
    
    public func getImageAsMedia() -> UIImage? {
        if let ret = self.foto {
            return UIImage(data: ret as Data)!
        }
        return nil
    }
}
