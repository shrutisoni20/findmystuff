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
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest( sortDescriptors: [NSSortDescriptor(keyPath: \Item.itemName, ascending: false)],animation: .default)
    
    private var items: FetchedResults<Item>
    
    var body : some View {
        AppBackgroundView{
            NavigationStack {
                List {
                        ForEach(items) { item in
                            Text(item.itemName ?? "Unknown Item")
                        }
                    }.padding(16)
            }
            .navigationTitle("My Stuff")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            isSearching = true
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                        NavigationLink(destination: AddItemView()) {
                            Image(systemName: "plus")
                                .font(.title2)
                        }
                    }
                    .navigationDestination(isPresented: $isSearching) {
                        SearchView()
                    }
                }
            }
        }
    }
}
