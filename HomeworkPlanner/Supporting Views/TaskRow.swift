//
//  Task.swift
//  HomeworkPlanner
//
//  Created by Zane Bookbinder on 4/27/20.
//  Copyright © 2020 Zane Bookbinder. All rights reserved.
//

import CoreData
import SwiftUI

struct TaskRow: View {
    @Environment(\.managedObjectContext) var moc

    var thisclass: Class_CD
    var task: Task_CD
    
    @State var editMode: Bool = false
    @State var urgent: Bool = false
    @State var editedTask = ""
    @State var editedDate = ""
    
    var body: some View {
        HStack(spacing: 3) {
            if(editMode == false){
                VStack(alignment: .leading, spacing: 3) {
                    Text(task.wrappedText)
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(Color.black)
                        .lineLimit(1)
                        .frame(width: 160, alignment: .leading)
                    
                    Text("due " + task.wrappedDueDate)
                        .fontWeight(.medium)
                        .foregroundColor(Color.black)
                        .lineLimit(1)
                }.padding(.leading, 5.0)
             }
            
            if(editMode == true){
                VStack(alignment: .leading, spacing: 3) {
                    TextField(editedTask, text: $editedTask)
                        .frame(width: 160, height: 15)
                        .background(Color("Dark Grey"))
                        .cornerRadius(7)
                        .foregroundColor(Color("Light Grey"))
                        .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.blue, lineWidth: 1))
                     
                    HStack(spacing: 2){
                        Text("due")
                            .fontWeight(.medium)
                            .foregroundColor(Color.black)
                        
                        TextField(editedDate, text: $editedDate)
                            .frame(width: 100, height: 15)
                            .background(Color("Dark Grey"))
                            .cornerRadius(7)
                            .foregroundColor(Color("Light Grey"))
                            .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.blue, lineWidth: 1))
                   }
                }.padding(.leading, 5.0)
                .padding(.bottom, -31)
            }
            
            if self.urgent {
                Button(action: {
                    self.task.isUrgent.toggle()
                    try? self.moc.save()
                    self.urgent.toggle()
                }) {
                    Text("􀁟").font(.system(size: 17)).foregroundColor(.red)
                }.frame(width: 20.0, height: 20.0)
                .fixedSize()
                .buttonStyle(PlainButtonStyle())
            } else{
                Button(action: {
                    self.task.isUrgent.toggle()
                    try? self.moc.save()
                    self.urgent.toggle()
                }) {
                    Text("􀁞").font(.system(size: 17)).foregroundColor(.black)
                }.frame(width: 20.0, height: 20.0)
                .fixedSize()
                .buttonStyle(PlainButtonStyle())
            }
            
            Button(action: {
                if(self.editMode == false){
                    self.gotoEditMode()
                } else{
                    self.exitEditMode()
                }
                self.editMode.toggle()
            }) {
                Text("􀈎").font(.system(size: 17)).foregroundColor(.black)
            }.frame(width: 20.0, height: 20.0)
            .fixedSize()
            .buttonStyle(PlainButtonStyle())

            Button(action: {
                self.deleteTask()
            }) {
                Text("􀈑").font(.system(size: 17)).foregroundColor(.black)
            }.frame(width: 20.0, height: 20.0)
            .fixedSize()
            .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 235.0)
        .onAppear() {
            self.urgent = self.task.isUrgent
        }
    }
    
    func deleteTask() {
        self.thisclass.removeFromTasks(self.task)
        try? self.moc.save()
    }
    
    func gotoEditMode() {
        editedTask = task.wrappedText
        editedDate = task.wrappedDueDate
    }
    
    func exitEditMode() {
        task.text = editedTask
        task.dueDate = editedDate
        try? self.moc.save()
    }
}

struct TaskRow_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let this_task = Task_CD(context: moc)
        this_task.text = "Example Task desiption"
        this_task.dueDate = "6/19"
        
        let this_class = Class_CD(context: moc)
        return TaskRow(thisclass: this_class, task: this_task)
    }
}
