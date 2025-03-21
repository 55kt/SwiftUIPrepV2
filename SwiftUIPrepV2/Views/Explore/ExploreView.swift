//
//  ExploreView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI
import CoreData

struct ExploreView: View {
    // MARK: - Properties
    let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    ) private var categories: FetchedResults<Category>
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Image("explore-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .opacity(0.4)
                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 15) {
                        if categories.isEmpty {
                            Text("No categories found")
                                .font(.headline)
                                .foregroundStyle(.red)
                        } else {
                            ForEach(categories) { category in
                                VStack {
                                    Image(category.iconName)
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                                    Text(category.name)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(width: 120, height: 160)
                                .padding()
                                .background(Material.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                            }
                        }
                    }// LazyVGrid
                    .padding()
                }// ScrollView
                .navigationTitle("Explore")
            }// ZStack
        }// NavigationStack
        .searchable(text: .constant(""), prompt: "Search for some question")
        .foregroundStyle(.primary)
    }// Body
}// View

// MARK: - Preview
#Preview {
    ExploreView()
}
