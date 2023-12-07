//
//  ContentView.swift
//  SpeedTips
//
//  Created by Harry Kwesi De Graft on 05/12/23.
//

import SwiftUI

struct ContentView: View {
    @State var bill: String = ""
    @State var selectedTipPercent = 0
    @State private var customTip: String = ""
    @State var personsToSplitBill = 1
    
    @State var billWithTip: String = "0.00"
    @State var totalBill: String = "0.00"
    @State var tip: String = "0.00"
    @State var tipPercentage = 0
    
    @State var showAlert = false
    
    let tipPercentages = [5, 10, 15]
    let step = 1
    let range = 1...20
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        return formatter
    }()
    
    func calculateTip()-> Void {
        
        guard let billAmountNumber = formatter.number(from: bill) else {
            showAlert = true
            return
        }
        
        let tipPercentage: Int
          
          if selectedTipPercent == tipPercentages.count {
              // Custom tip
              tipPercentage = Int(customTip) ?? 0
          } else {
              // Selected from predefined percentages
              tipPercentage = tipPercentages[selectedTipPercent]
          }
        
        let billAmount = Float(truncating: billAmountNumber)
        let finalTipPercentage = Float(tipPercentage)/100.00
        let tipAmount = billAmount * finalTipPercentage
        let totalBillWithTip = billAmount + tipAmount
        
        var billWithTip: Float = 0.0
        
        if personsToSplitBill > 1 {
            billWithTip = totalBillWithTip / Float(personsToSplitBill)
        } else {
            billWithTip = totalBillWithTip
        }
        
        self.billWithTip = formatter.string(from: NSNumber(value: billWithTip)) ?? "0.00"
        self.totalBill = formatter.string(from: NSNumber(value: totalBillWithTip)) ?? "0.00"
        self.tip = formatter.string(from: NSNumber(value: tipAmount)) ?? "0.00"
        self.tipPercentage = Int(finalTipPercentage * 100)
       
    }
    
    func resetValue()-> Void {
        billWithTip = "0.00"
        totalBill = "0.00"
        tip = "0.00"
    }
    
    var body: some View {
        VStack (spacing: 30) {
            Text("Tip well, spread joy")
                .font(.title2)
                .fontWeight(.bold)
            CardView(
                billWithTip: $billWithTip,
                totalTip: $tip,
                tipPercent: $tipPercentage,
                originalBill: $bill,
                totalBill: $totalBill,
                billPersons: $personsToSplitBill
            )
            
          
            VStack(alignment: .leading) {
                Text("Enter your total bill amount")
                TextField("", text: $bill)
                    .font(.system(size: 22))
                    .padding()
                    .frame(width: 350, height: 50)
                    .border(Color.gray, width: 2.5)
                    .cornerRadius(5)
                    .accessibility(label: Text("Enter your total bill amount"))
            }
            
            VStack(alignment: .leading){
                Text("Select Desired Tip Percent %")
                Picker("Tip", selection: $selectedTipPercent) {
                    ForEach(tipPercentages.indices, id: \.self) { index in
                        Text("\(self.tipPercentages[index])%")
                                    .tag(index)
                    }
                    Text("Custom")
                        .tag(tipPercentages.count)
                }
                .pickerStyle(.segmented)
                
                if selectedTipPercent == tipPercentages.count {
                    TextField("Enter custom tip %", text: $customTip)
                        .keyboardType(.numberPad)
                        .font(.system(size: 22))
                        .padding()
                        .frame(width: 350, height: 50)
                        .border(Color.gray, width: 2.5)
                        .cornerRadius(5)
                        .accessibility(label: Text("Enter custom tip percentage"))
                }
            }
            
            VStack(alignment: .leading){
                Text("Want to split the Bill?").foregroundColor(Color.gray)
                Stepper(value: $personsToSplitBill , in: range, step:step){
                    HStack{
                        Text("Split by Persons: ")
                        Text("\(personsToSplitBill)").font(.title2)}
                }
            }
            
            Button(action: {
                calculateTip()
            }, label: {
                Text("Calculate")
                    .frame(width: 350, height:60)
                    .font(.system(size: 22, weight: .bold))
                    .textCase(.uppercase)
                    .foregroundColor(Color.white)
                    .background(Color("AppTheme"))
                    .cornerRadius(5)
            })
            
            
            Button(action: {
                resetValue()
                personsToSplitBill = 1
                tipPercentage = 0
            }, label: {
                Text("Cancel")
                    .frame(width: 350, height:60)
                    .font(.system(size: 22, weight: .bold))
                    .textCase(.uppercase)
                    .foregroundColor(Color.white)
                    .background(Color.gray.opacity(0.7))
                    .cornerRadius(5)
            })
            
        }
        .alert("Please enter a valid amount", isPresented: $showAlert) {
            Button("OK", role: .cancel){}
        }
        .padding(.leading,20)
        .padding(.trailing,20)
        .onChange(of: bill) { newValue in
            if newValue.isEmpty{
                resetValue()
            }
        }
        .onChange(of: selectedTipPercent) {  _ in
            resetValue()
        }
    }
}

#Preview {
    ContentView()
}
