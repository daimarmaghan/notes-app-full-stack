//
//  ContentView.swift
//  notesApp
//
//  Created by Daim Armaghan on 10/07/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var Notes = [Note]()
    @State var addOrNot = false
    @State var showAlert = false
    @State var toDelete : Note?
    @State var editMode : EditMode = .inactive
    @State var toUpdate : String=""
    @State var toUpdateID : String=""
    var alert : Alert {
        Alert(title: Text("Delete"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete"), action: deleteClicked), secondaryButton: .cancel())
    }

    var body: some View {
        NavigationView{
            List(){
                ForEach(Notes) { note in
                    if let noter = note.note {
                        if editMode == .inactive{
                            Text(noter)
                                .onLongPressGesture {
                                    showAlert.toggle()
                                    toDelete=note
                                }
                        }
                        else if editMode == .active{
                            HStack{
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.yellow)
                                Text(noter)
                            }
                            .onTapGesture {
                                toUpdate=note.note!
                                toUpdateID=note._id
                                print("---: ", note._id)
                                self.addOrNot.toggle()
                            }
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert ,content: {alert})
            .sheet(isPresented: $addOrNot,onDismiss: fetchData, content: {
                if editMode == .inactive{
                    AddText()
                }
                else if editMode == .active{
                    UpdateNotes(text: $toUpdate, noteID: $toUpdateID)
                }
                
            })
            .onAppear(perform: fetchData)
            .navigationTitle("Notes")
            .navigationBarItems(leading: Button(action: {
                if editMode == .inactive{
                    editMode = .active
                }
                else if editMode == .active{
                    editMode = .inactive
                }
            }, label: {
                if editMode == .inactive{
                    Text("Edit")
                }
                else if editMode == .active{
                    Text("Done")
                }
            }),trailing: Button(action: {
                print("I'm pressed")
                addOrNot.toggle()
                
            }, label: {
                Text("Add")
            }))
        }
            
    }
    
    func deleteClicked(){
        guard let id = toDelete?.id else {return}
        var url = URL(string:"http://localhost:3000/notes/\(id)")!
        var request = URLRequest(url: url)
        
        var session = URLSession.shared
        
        request.httpMethod = "DELETE"
    
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var task = session.dataTask(with: request){ data, res, err in
            guard err == nil else {return}
            guard let data = data else {return}
            print(data)
        }
        task.resume()
        toDelete=nil
        fetchData()
    }
    
    func fetchData(){
        var url = URL(string: "http://localhost:3000/notes")!
        var task = URLSession.shared.dataTask(with: url, completionHandler: { (data, res, err) in
            guard let data = data else {return}
            print(String(data: data, encoding: String.Encoding.utf8) ?? "No res")
            if let notess = try? JSONDecoder().decode([Note].self, from: data) {
                Notes=notess
                print(notess)
            }
        })
        task.resume()
        
    }
}
struct Note: Identifiable, Codable{
    var id: String {_id}
    var _id: String
    var note: String?
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
