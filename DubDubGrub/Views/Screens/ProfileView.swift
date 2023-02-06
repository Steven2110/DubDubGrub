//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Steven Wijaya on 01.12.2022.
//

import SwiftUI
import CloudKit

struct ProfileView: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var position: String = ""
    @State private var bioText: String = ""
    @State private var avatar = ImagePlaceHolder.avatar
    
    @State private var isShowingPhotoPicker: Bool = false
    
    @State private var alertItem: AlertItem?
    
    var body: some View {
        VStack {
            ZStack {
                profileDataBackground
                HStack {
                    profileImage
                    VStack {
                        profileFirstName
                            .profileNameStyle()
                        profileLastName
                            .profileNameStyle()
                        profilePosition
                    }
                    Spacer()
                }
                .padding()
            }
            .padding()
            VStack {
                HStack {
                    bioCharactersRemain
                    Spacer()
                    Button {
                        
                    } label: {
                        checkOutButtonLabel
                    }
                }
                bioTextBox
            }
            .padding(.horizontal)
            Spacer()
            Button {
                dismissKeyboard()
                createProfile()
            } label: {
                DDGButton(title: "Save Profile")
                    .padding()
            }
        }
        .navigationTitle("Profile")
        .toolbar {
            Button {
                dismissKeyboard()
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        }
        .onAppear { getProfile() }
        .alert(item: $alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        })
        .sheet(isPresented: $isShowingPhotoPicker) {
            PhotoPicker(image: $avatar)
        }
    }
}

extension ProfileView {
    private var profileDataBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color(.secondarySystemBackground))
            .frame(height: 150)
    }
    
    private var profileFirstName: some View {
        TextField("First Name", text: $firstName)
    }
    
    private var profileLastName: some View {
        TextField("Last Name", text: $lastName)
    }
    
    private var profilePosition: some View {
        TextField("Position", text: $position)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
    }
    
    private var profileImage: some View {
        ZStack {
            AvatarView(image: avatar, size: 90)
            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
                .offset(y: 33)
        }
        .onTapGesture {
            isShowingPhotoPicker = true
        }
    }
    
    private var bioCharactersRemain: some View {
        Group {
            Text("Bio: ")
            +
            Text("\(100 - bioText.count)")
                .foregroundColor(bioText.count <= 100 ? .brandPrimary : .pink)
                .bold()
            +
            Text(" characters remain")
        }
        .font(.callout)
        .foregroundColor(.secondary)
    }
    
    private var checkOutButtonLabel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.red)
                .frame(width: 110,height: 30)
            Label("Check Out", systemImage: "mappin.and.ellipse")
                .foregroundColor(.white)
                .font(.caption)
        }
    }
    
    private var bioTextBox: some View {
        TextEditor(text: $bioText)
            .frame(height: 100)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary, lineWidth: 2)
            )
        
    }
    
    func checkProfileValidity() -> Bool {
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !position.isEmpty,
              !bioText.isEmpty,
              avatar != ImagePlaceHolder.avatar,
              bioText.count < 100
        else { return false }
        
        return true
    }
    
    func createProfile() {
        guard checkProfileValidity() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        
        // Create CKRecord from profile form
        let profileRecord = CKRecord(recordType: RecordType.profile)
        profileRecord[DDGProfile.cFirstName] = firstName
        profileRecord[DDGProfile.cLastName] = lastName
        profileRecord[DDGProfile.cPosition] = position
        profileRecord[DDGProfile.cBio] = bioText
        profileRecord[DDGProfile.cAvatar] = avatar.convertToCKAsset()
        
        // Get UserRecordID from container
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }
            print("This is record ID from container: \(recordID)")
            
            // Get UserRecord from public database
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                print("This is user record from database: \(userRecord)")
                
                // Create reference on UserRecord to the DDGProfile
                userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
                
                // Create CKOperation to save User and Profile Records
                let operation = CKModifyRecordsOperation(recordsToSave: [userRecord, profileRecord])
                operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordsID, error in
                    guard let savedRecords = savedRecords, error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    print(savedRecords)
                }
                
                CKContainer.default().publicCloudDatabase.add(operation) // Same as `task.resume()`
            }
        }
    }
    
    func getProfile() {
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }
            print("This is record ID from container: \(recordID)")
            
            // Get UserRecord from public database
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                let profileReference = userRecord["userProfile"] as! CKRecord.Reference
                let profilRecordID = profileReference.recordID
                
                CKContainer.default().publicCloudDatabase.fetch(withRecordID: profilRecordID) { profileRecord, error in
                    guard let profileRecord = profileRecord, error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let profile = DDGProfile(record: profileRecord)
                        firstName = profile.firstName
                        lastName = profile.lastName
                        position = profile.position
                        bioText = profile.bio
                        avatar = profile.createAvatarImage()
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}
