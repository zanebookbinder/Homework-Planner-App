//
//  ContentView.swift
//  HomeworkPlanner
//
//  Created by Zane Bookbinder on 4/25/20.
//  Copyright © 2020 Zane Bookbinder. All rights reserved.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State var request: NSFetchRequest<Class_CD> = Class_CD.fetchRequest()
                
    @State var newClass = ""
    @ObservedObject var numClasses: SharedInt = SharedInt()
    
    @State var editName = false
    @State var userName: String = UserDefaults.standard.string(forKey: "userName") ?? "Tom Brady"
    
    var body: some View {
        let dateString = getDate()

        return VStack{
            HStack {
                Text(dateString)
                    .font(.headline)
                    .padding([.top, .leading], 14.0)
                    .foregroundColor(.white)
                
                Spacer()
                
                if self.editName == false {
                    Text(userName + "'s Homework Planner")
                        .font(.title)
                        .padding(.bottom, -12)
                } else{
                    TextField(userName, text: $userName)
                        .frame(width: 500)
                        .font(.title)
                        .padding(.bottom, -12)
                        .padding(.top, 8)
                        .textFieldStyle(SquareBorderTextFieldStyle())
                }
                
                Button(action: {
                    self.editName ? self.fromEditName(): self.toEditName()
                    self.editName.toggle()
                }) {
                    Text("􀈎").font(.title).foregroundColor(.white)
                }.buttonStyle(PlainButtonStyle())
                .padding(.top, 15)
                .frame(height: 35)
                
                Spacer()
            }
            
            Divider().frame(height: 2.0).background(Color.gray)
            
            ClassGrid(numClasses: numClasses).environment(\.managedObjectContext, self.moc)
            
            HStack {
                if(numClasses.num < 10){
                    Text("Enter a new class name here:")
                        .foregroundColor(.white)
                        .font(.system(size: 25))

                    TextField("", text: $newClass)
                        .frame(width: 300.0, height: 30.0)
                        .background(Color("Light Grey"))
                        .cornerRadius(12)
                        .foregroundColor(Color("Dark Grey"))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.red, lineWidth: 3))
                    
                    Button(action: {
                        self.addClass(name: self.newClass)
                        self.newClass = ""
                    }) {
                        Text("􀃜").frame(width:35, height: 30).font(.largeTitle).foregroundColor(.white)
                    }
                    .frame(width: 30.0, height: 30.0)
                    .fixedSize()
                    .buttonStyle(PlainButtonStyle())
                }
                else{
                    Text("Maximum number of classes reached. Delete one to add more.")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    
                    Button(action: {}) {
                        Text("􀃜").frame(width:35, height: 30).font(.largeTitle).foregroundColor(Color("Dark Grey"))
                    }
                    .frame(width: 30.0, height: 30.0)
                    .fixedSize()
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
        }.padding([.leading, .bottom, .trailing], 10.0).background(Color.blue)
        .onAppear(){
            self.numClasses.num =  Int((try? self.moc.count(for: self.request)) ?? 0)
        }
    }
    
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }
    
    func addClass(name: String) {
        let newclass = Class_CD(context: moc)
        newclass.class_name = name
        newclass.id = UUID()
        newclass.createdAt = Date()
        try? moc.save()
        
        self.numClasses.num += 1
    }
    
    func toEditName() {
        
    }
    
    func fromEditName() {
        UserDefaults.standard.set(userName, forKey: "userName")
        print(userName)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(numClasses: SharedInt())
    }
}

class SharedInt: ObservableObject {
    @Published var num = 0
}
