//
//  Contato+CoreDataProperties.swift
//  DesafioTabelas
//

import Foundation
import CoreData


extension Contato {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contato> {
        return NSFetchRequest<Contato>(entityName: "Contato")
    }

    @NSManaged public var nome: String?
    @NSManaged public var telefone: String?
    @NSManaged public var foto: NSData?

}
