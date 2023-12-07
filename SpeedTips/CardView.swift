//
//  CardView.swift
//  SpeedTips
//
//  Created by Harry Kwesi De Graft on 05/12/23.
//

import SwiftUI

struct CardView: View {
    @Binding var billWithTip: String
    @Binding var totalTip: String
    @Binding var tipPercent: Int
    @Binding var originalBill: String
    @Binding var totalBill: String
    @Binding var billPersons: Int
    
    var body: some View {
        VStack(spacing:5){
            Group{
                Text("Total per person: \(billWithTip)")
                Text("Grand Total: \(totalBill)")
            }.font(.title2)
            
            Group{
                Text("Bill : \(originalBill)")
                Text("Your Tip: \(totalTip)(\(tipPercent)%)")
                Text("Split By: \(billPersons)")
            }
        }.frame(width:350, height: 200)
        .background(Color("CardBg")).cornerRadius(10)
    }
}

#Preview {
    CardView(billWithTip: .constant("0"), totalTip: .constant("0"), tipPercent: .constant(10), originalBill: .constant("0"), totalBill: .constant("0"), billPersons: .constant(10) )
}
