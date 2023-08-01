//
//  UpdateNotes.swift
//  notesApp
//
//  Created by Daim Armaghan on 10/07/2023.
//

import SwiftUI

struct UpdateNotes: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var text: String
    @Binding var noteID: String
    var body: some View {
        VStack{
            HStack{
                TextField("Update Note", text: $text)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                Button("Update", action: {
                    print("Update Text")
                    updateClicked()
                })
                .padding()
            }
            .border(.black)
            .cornerRadius(CGFloat(8))
            
            .padding()
            Button(role: .cancel, action: {
                text=""
                presentationMode.wrappedValue.dismiss()
            }, label: {Text("Cancel").padding(.horizontal)})
            .buttonStyle(.borderedProminent)
        }
    }
    
    func updateClicked(){
        var params=["note" : text] as? [String : Any]
        print("noteID: ", noteID)
        var url = URL(string:"http://localhost:3000/notes/\(self.noteID)")!
        var request = URLRequest(url: url)
        
        var session = URLSession.shared
        
        request.httpMethod = "PATCH"
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
            do {
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
        text=""
        presentationMode.wrappedValue.dismiss()
    }
}

struct UpdateNotes_Previews: PreviewProvider {
    static var previews: some View {
        @State var texte:String=""
        UpdateNotes(text: $texte,noteID: $texte)
    }
}
