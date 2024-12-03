//
//  PopupView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-12-02.
//

import SwiftUI

struct PopupView: View {
    @State var showingPopup = false
    
    var body: some View {
        VStack {
            Button{
                showingPopup.toggle()
            } label: {
                Text("Show Popup")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding(20)
    }
}

struct CustomAlert<Contnet: View>: View{
    @Binding var showAlert: Bool
    
    var color: Color = .cyan
    
    let content: Contnet
    
    init(showAlert: Binding<Bool>, color: Color, @ViewBuilder content : () -> Contnet){
        self._showAlert = showAlert
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
                .opacity(showAlert ? 0.5 : 0)
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.3)){
                        showAlert.toggle()
                    }
                }
            
            VStack{
                content
            }
            
            .opacity(showAlert ? 1 : 0)
            .scaleEffect(showAlert ? 1 : 0)
        }
    }
}

#Preview {
    PopupView()
}
