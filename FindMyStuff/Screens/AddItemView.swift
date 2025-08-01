//
//  AddItemView.swift
//  FindMyStuff
//
//  Created by Shruti Soni on 29/07/25.
//

import SwiftUI
import PhotosUI
import Foundation

struct AddItemView: View {
    @State private var selectedImage: UIImage?
    @State private var showPhotoPicker = false
    @State private var showCamera = false
    @State private var showActionSheet = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var itemName = ""
    @State private var itemDescription = ""
    
    @Environment(\.managedObjectContext) private var viewcontext
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack() {
                    Group {
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(12)
                        } else {
                            Rectangle()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(12)
                            //  .fill(Color.gray.opacity(0.2))
                            //  .frame(height: 200)
                            //  .overlay(Text("No image selected").foregroundColor(.gray))
                            //  .cornerRadius(12)
                        }
                        
                        Button("Add Image") {
                            showActionSheet = true
                        }
                        .confirmationDialog("Select Image Source", isPresented: $showActionSheet, titleVisibility: .visible) {
                            Button("Take Photo") {
                                showCamera = true
                            }
                            Button("Choose from Library") {
                                showPhotoPicker = true
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Item Name")
                            .font(.headline)
                        TextField("Enter item name", text: $itemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Describe item location")
                            .font(.headline)
                        TextEditor(text: $itemDescription
                        )
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        Button(action: {
                            saveItem()
                        }) {
                            Text("Save Item")
                                .font(.headline)
                                .frame(maxWidth: .infinity, minHeight: 45)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.top, 20)
                        }
                    }.padding(.horizontal,16)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                }
            }
            .navigationTitle("Add Items")
            .toolbarTitleDisplayMode(.inline)
            .photosPicker(isPresented: $showPhotoPicker, selection: $photoPickerItem, matching: .images)
            .onChange(of: photoPickerItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraView(image: $selectedImage)
            }
        }
    }
    
    func saveItem() {
        guard !itemName.isEmpty, !itemDescription.isEmpty, let image = selectedImage else {
           
            print("Please fill in all fields and select an image.")
            return
        }
       
        let newItem = Item(context: viewcontext)
        newItem.itemName = itemName
        newItem.itemDescription = itemDescription
        newItem.itemImage = image.jpegData(compressionQuality: 0.8)
        
        do {
            try viewcontext.save()
            alertMessage = "Item saved successfully!"
            print("Item saved successfully!")
            itemName = ""
            itemDescription = ""
            selectedImage = nil
        } catch {
            print("Failed to save item: \(error.localizedDescription)")
        }
        showAlert = true
    }
}
