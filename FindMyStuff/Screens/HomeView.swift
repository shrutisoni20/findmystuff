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
    @State private var navigate = false

    var body: some View {
        NavigationStack {
            VStack{
                Image("FindMyStuff").resizable()
            }
            Button(action: {
                navigate = true
            }) {
                Text("Let's begin to add items").frame( maxWidth: .infinity)
                    .font(.title2)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.top, 10)
                    .scaleEffect(animate ? 1.2 : 1.0)
                            .animation(.interpolatingSpring(stiffness: 100, damping: 5), value: animate)
            }
            .navigationDestination(isPresented: $navigate) {
                ItemListView()
            }
        }
        Spacer()
            .onAppear{
                animate.toggle()
      }
    }
}


#Preview {
    HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
