//
//  HomeView.swift
//  FindMyStuff
//
//  Created by Shruti Soni on 28/07/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var animate = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationStack {
            VStack{
                Image("FindMyStuff").resizable()
            }
            Button(action: {
                animate.toggle()
            }) {
                Text("Let's begin to add items").frame( maxWidth: .infinity)
                    .font(.title2)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.top, 10)
                    .scaleEffect(animate ? 1.2 : 1.0)
                            .animation(.interpolatingSpring(stiffness: 100, damping: 5), value: animate)
            }
        }
        Spacer()
        
    }
}


#Preview {
    HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}


//VStack(alignment: .leading, spacing: 25){
//    Text("Find My Stuff").bold().font(.title)
//    Text("Visually catalog where you've stored your items and easily locate them later.")
//Button(
//    action: {
//
//    })
//{
//    HStack {
//        Image(systemName: "camera.fill")
//            .font(.title)
//        Text("Add Item")
//            .font(.title2)
//
//    }.frame(maxWidth: .infinity, alignment: .leading)
//}
//.buttonStyle(.borderedProminent)
//.cornerRadius(25)
// Text("Storage Locations").bold().font(.headline)
//}.padding()
