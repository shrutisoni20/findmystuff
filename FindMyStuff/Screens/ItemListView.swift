//
//  ItemListView.swift
//  FindMyStuff
//
//  Created by Shruti Soni on 29/07/25.
//

import Foundation
import SwiftUI
import CoreData

struct ItemListView : View {
    
    @State private var isSearching = false
    @State private var searchText = ""
    @State private var selectedIem: Item? = nil
    @State private var showAlert = false
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest( sortDescriptors: [NSSortDescriptor(keyPath: \Item.itemName, ascending: false)],animation: .default)
    
    private var items: FetchedResults<Item>
    
    var filteredItems : [Item] {
        if searchText.isEmpty {
            return Array(items)
        } else {
            return items.filter {
                (($0.itemName ?? "").localizedCaseInsensitiveContains(searchText) ||  ($0.itemDescription ?? "").localizedCaseInsensitiveContains(searchText))
            }
        }
    }
    
    var body : some View {
        AppBackgroundView{
            VStack (alignment: .leading) {
                if isSearching {
                    HStack(){
                       
                        TextField("Search items...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal, 20)}
                List {
                    ForEach(filteredItems) { item in
                        HStack {
                            if let imageData = item.itemImage, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                                    .foregroundColor(.gray)
                            }
                            VStack(alignment: .leading) {
                                Text(item.itemName ?? "Unknown Item")
                                Text(item.itemDescription ?? "No Description")
                            }
                        }
                        .onTapGesture {
                            selectedIem = item
                            searchText = ""
                            isSearching = false
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .alert("", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("The item has been deleted successfully.")
            }
            .padding(30)
            .background(Color.clear)
            .scrollContentBackground(.hidden)
            .navigationDestination(item : $selectedIem) { item in
                AddItemView(item: item)
            }
            .navigationTitle("My Stuff")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            isSearching.toggle()
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                        NavigationLink(destination: AddItemView()) {
                            Image(systemName: "plus")
                                .font(.title2)
                        }
                    }
                }
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = filteredItems[index]
            viewContext.delete(item)
            
        }
        do {
            try viewContext.save()
            showAlert = true
        } catch {
            print("Error deleting item: \(error.localizedDescription)")
        }
    }
}
