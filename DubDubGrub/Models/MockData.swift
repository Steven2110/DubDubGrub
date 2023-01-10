//
//  MockData.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 12.12.2022.
//

import CloudKit

struct MockData {
    static var location: CKRecord {
        let record = CKRecord(recordType: RecordType.location)
        record[DDGLocation.cName] = "Burger King"
        record[DDGLocation.cDescription] = "Сеть ресторанов быстрого питания"
        record[DDGLocation.cAddress] = "ТРЦ Изумрудный город, Комсомольский проспект, 13Б"
        record[DDGLocation.cLocation] = CLLocation(latitude: 56.483140, longitude: 84.983040)
        record[DDGLocation.cPhoneNumber] = "+7 (495) 544-50-00"
        record[DDGLocation.cWebsiteURL] = "http://burgerkingrus.ru/"
        
        return record
    }
}
