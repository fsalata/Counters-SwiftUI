//
//  ExamplesView.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 04/11/21.
//

import SwiftUI

struct ExamplesView: View {
    private let viewModel = ExamplesViewModel()

    @Environment(\.presentationMode) var presentationMode

    @Binding var selected: String

    var backButton : some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack(spacing: 0) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                Text("Create")
                    .padding(.leading, 6)
            }
            .foregroundColor(Color(named: .orange))
            .offset(x: -8)
        }
    }

    func getSectionExamples(_ key: String) -> [Example] {
        return viewModel.examples[key] ?? []
    }

    func capitalizeTitle(_ title: String) -> String {
        return title.capitalizingFirstLetter()
    }

    var body: some View {
        ZStack {
            Color(named: .lighterGrey)
                .ignoresSafeArea(edges: [.trailing, .bottom, .leading])

            VStack {
                Text("Select an example to add it to your counters.")
                    .font(.system(size: 15, weight: .light))
                    .foregroundColor(Color(named: .darkSilver))
                    .padding([.top, .trailing, .leading], 16)

                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black.opacity(0.20))
                    .padding(.top, 4)

                VStack(alignment: .leading, spacing: 32) {
                    ForEach(viewModel.sectionKeys, id: \.self) { key in
                        VStack(alignment: .leading) {
                            Text(key.uppercased())
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex6: 0x4A4A4A))
                                .padding(.leading, 16)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    Color.clear.frame(width: 1, height: 8)
                                    ForEach(getSectionExamples(key), id: \.self) { example in
                                        Text(capitalizeTitle(example.name))
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 16)
                                            .background(Color.white)
                                            .cornerRadius(8)
                                            .onTapGesture {
                                                selected = example.name.capitalizingFirstLetter()
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top, 32)
                .frame(maxWidth: .infinity)

                Spacer()
            }
            .navigationTitle(Text("Examples"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
        }
    }
}

struct ExamplesView_Previews: PreviewProvider {
    static var previews: some View {
        ExamplesView(selected: .constant(""))
    }
}
