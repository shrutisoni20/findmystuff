//
//  AddItemView.swift
//  FindMyStuff
//
//  Created by Shruti Soni on 29/07/25.
//

import SwiftUI
import PhotosUI
import Foundation


enum ActiveAlert: Identifiable {
    case success
    case error

    var id: Int {
        switch self {
        case .success: return 0
        case .error: return 1
        }
    }
}

struct AddItemView: View {
    @State private var selectedImage: UIImage?
    @State private var showPhotoPicker = false
    @State private var showCamera = false
    @State private var showActionSheet = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var activeAlert: ActiveAlert?
    @State private var alertMessage = ""
    @State private var itemName = ""
    @State private var itemDescription = ""
    var item: Item? = nil

    @Environment(\.managedObjectContext) private var viewcontext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        AppBackgroundView {
            ScrollView {
                VStack(spacing: 32) {
                    Group {
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(12)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 200)
                                .cornerRadius(12)
                                .overlay(Text("No image selected").foregroundColor(.gray))
                        }
                        Button("Add Image") {
                            showActionSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                        .confirmationDialog("Select Image Source", isPresented: $showActionSheet, titleVisibility: .visible) {
                            Button("Take Photo") { showCamera = true }
                            Button("Choose from Library") { showPhotoPicker = true }
                            Button("Cancel", role: .cancel) {}
                        }
                    }
                    VStack(alignment: .leading, spacing: 20) {
                        RichTextField(title: "Item Name", text: $itemName)
                        RichTextField(title: "Describe item location", text: $itemDescription)
                        Button(action: { saveItem() }) {
                            Text("Save Item")
                                .font(.headline)
                                .frame(maxWidth: .infinity, minHeight: 45)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .padding(.top, 20)
                        }
                        .alert(item: $activeAlert) { alert in
                            switch alert {
                            case .success:
                                return Alert(
                                    title: Text(""),
                                    message: Text(alertMessage),
                                    dismissButton: .default(Text("OK")) { dismiss() }
                                )
                            case .error:
                                return Alert(
                                    title: Text(""),
                                    message: Text(alertMessage),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                        }
                    }
                    .padding(24)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                    )
                   
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 24)
            }
        }
        .navigationTitle("Add Items")
        .toolbarTitleDisplayMode(.inline)
        .photosPicker(isPresented: $showPhotoPicker, selection: $photoPickerItem, matching: .images)
        .onChange(of: photoPickerItem) { _, newItem in
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
        .onAppear {
            if let item = item {
                itemName = item.itemName ?? ""
                itemDescription = item.itemDescription ?? ""
                if let imageData = item.itemImage {
                    selectedImage = UIImage(data: imageData)
                }
            }
        }
    }

    func saveItem() {
        guard !itemName.isEmpty, !itemDescription.isEmpty, let image = selectedImage else {
            print("Please fill in all fields and select an image.")
            alertMessage = "Please fill in all fields and select an image."
            activeAlert = .error
            return
        }
        if let existingItem = item {
            existingItem.itemName = itemName
            existingItem.itemDescription = itemDescription
            existingItem.itemImage = image.jpegData(compressionQuality: 0.8)
            print("Item updated successfully!")
            alertMessage = "Item updated successfully!"
            activeAlert = .success
        } else {
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
            activeAlert = .success
        }
    }
}
