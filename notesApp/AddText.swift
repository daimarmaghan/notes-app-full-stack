//
//  AddText.swift
//  notesApp
//
//  Created by Daim Armaghan on 10/07/2023.
//

import SwiftUI

struct AddText: View {
    @Environment(\.presentationMode) var presentationMode
    @State var texted = String()
    var body: some View {
        VStack{
            HStack{
                TextField("Add Note", text: $texted)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                Button("Add", action: {
                    print("Added Text")
                    addClicked()
                })
                .padding()
            }
            .border(.black)
            .cornerRadius(CGFloat(8))
            
            .padding()
            Button(role: .cancel, action: {
                texted=""
                presentationMode.wrappedValue.dismiss()
            }, label: {Text("Cancel").padding(.horizontal)})
            .buttonStyle(.borderedProminent)
        }
        
    }
    
    func addClicked(){
        var params=["note" : texted] as? [String : Any]
        var url = URL(string:"http://localhost:3000/notes")!
        var request = URLRequest(url: url)
        
        var session = URLSession.shared
        
        request.httpMethod = "POST"
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        catch{
            print(error)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var task = session.dataTask(with: request){ data, res, err in
            guard err == nil else {return}
            guard let data = data else {return}
            do{
                if let data = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                {
                    print(data)
                }
            }
            catch
            {
                print(error)
            }
        }
        task.resume()
        texted=""
        presentationMode.wrappedValue.dismiss()
    }
}
struct AddText_Previews: PreviewProvider {
    static var previews: some View {
        AddText()
    }
}
