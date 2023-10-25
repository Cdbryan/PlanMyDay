//
//  InputView.swift
//  Plan My Day
//
//  Created by Itzel Villanueva on 10/25/23.
//


//resuable component for the textfields
import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            if isSecureField{
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
            }
            else{
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
            }
            Divider()
        }
    }
}

//what it looks like when we have input
struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email", placeholder: "tommyT11@usc.edu")
    }
}
