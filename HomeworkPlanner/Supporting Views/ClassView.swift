//
//  ClassView.swift
//  HomeworkPlanner
//
//  Created by Zane Bookbinder on 4/28/20.
//  Copyright © 2020 Zane Bookbinder. All rights reserved.
//

import SwiftUI
import CoreData

struct ClassView: View {
    @Environment(\.managedObjectContext) var moc
    
    var this_class: Class_CD
    var background: Color
    var tasks: [Task_CD]
    
    @State var newTask = ""
    @State var newDate = ""
    @State var isUrgent = false
    @State var classNameText = ""
    @State var editMode = false
    
    @ObservedObject var numClasses: SharedInt
         
    var body: some View {
        let className: String = this_class.wrappedClassName
        
        return VStack(spacing: 3) {
//            if this_class.taskArray.count > 3 {
//                Spacer()
//            }
            HStack {
                Button(action: {
                    self.editMode ? self.fromEditMode(): self.toEditMode()
                    self.editMode.toggle()
                }) {
                    Text("􀈎").foregroundColor(.black).font(.system(size: 21, weight: .bold))
                }.buttonStyle(PlainButtonStyle())
                .padding(.top, 2)
                .padding(.leading, 15)
                 
                Spacer()
                
                if self.editMode == false {
                    Text(className)
                    .font(.headline)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .frame(width: 140)
                } else{
                    TextField(this_class.wrappedClassName, text: $classNameText)
                        .frame(width: 140)
                        .foregroundColor(Color.black)
                        .font(.system(size: 15, weight: .bold))
                }
                
                Spacer()
                
                Button(action: {
                       self.removeClass(toremove: self.this_class)
                   }) {
                       Text("􀈑").frame(width:30, height: 30).font(.system(size: 25)).foregroundColor(.black)
                   }
                   .padding(.top, 3)
                   .padding(.trailing, 12)
                   .fixedSize()
                   .buttonStyle(PlainButtonStyle())
            } //end of title HStack
            
            if self.this_class.taskArray.count < 5 {
                VStack(spacing: 5) {
                    ForEach(self.this_class.taskArray, id: \.self) { one_task in
                        return TaskRow(thisclass: self.this_class, task: one_task).environment(\.managedObjectContext, self.moc)
                    }
                }.background(background)
            }else{
                VStack(spacing: 5) {
                    ForEach(0..<4) {
                        TaskRow(thisclass: self.this_class, task: self.this_class.taskArray[$0]).environment(\.managedObjectContext, self.moc)
                    }
                }.background(background)
            }
            
            Spacer()
            
            HStack(spacing: 5) {
                VStack(spacing: 5) {
                    Spacer()
                    Text("Enter your new task and due date:")
                        .foregroundColor(Color.black)
                        .font(.system(size: 10))
                        .frame(width: 165)
                    
                    TextField(this_class.taskArray.count > 0 ? "": "ex. Read to page 50", text: $newTask)
                        .padding(.leading, 2.0)
                        .frame(width: 165.0, height: 20.0)
                        .background(Color("Dark Grey"))
                        .cornerRadius(10)
                        .foregroundColor(Color("Light Grey"))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                    
                    TextField(this_class.taskArray.count > 0 ? "": "ex. Friday or 5/31", text: $newDate)
                        .padding(.leading, 2.0)
                        .frame(width: 125, height: 20.0)
                        .background(Color("Dark Grey"))
                        .cornerRadius(10)
                        .foregroundColor(Color("Light Grey"))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                }
                .padding([.leading, .bottom], 7.0)
                .frame(height: 70.0)
                //end of bottom left VStack (textfields for new task)
                
                Button(action: {
                    self.isUrgent.toggle()
                }) {
                    if self.isUrgent {
                        Text("􀁟").font(.system(size: 22)).foregroundColor(.red)
                    } else {
                        Text("􀁞").font(.system(size: 22)).foregroundColor(.black)
                    }
                }
                .frame(width: 25, height: 20)
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    self.addTask(text: self.newTask, dueDate: self.newDate)
                            }) {
                                Text("􀑍").font(.system(size: 30)).foregroundColor(.black)

                }
                .frame(width: 30.0)
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 15)
            }
            .padding([.bottom, .leading], 8.0)
            .frame(height: 70.0)
            //end of new task submission HStack
        }
        .frame(width: 240, height: 275)
        .background(background)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.black, lineWidth: 2))
            .onAppear(){
                self.classNameText = self.this_class.class_name ?? ""
                }
        //end of VStack
    }
    func removeClass(toremove: Class_CD) {
        if numClasses.num > 1 {
            moc.delete(toremove)
            try? moc.save()
            
            self.numClasses.num -= 1
        }
    }
    
    func addTask(text: String, dueDate: String){
        let toadd = Task_CD(context: moc)
        toadd.dueDate = dueDate
        toadd.text = text
        toadd.createdAt = Date()
        toadd.isDone = false
        toadd.isUrgent = self.isUrgent
        toadd.class_name = self.this_class

        try? moc.save()
        moc.refresh(self.this_class, mergeChanges: true)
        self.newTask = ""
        self.newDate = ""
    }
    
    func toEditMode() {
    }
    
    func fromEditMode() {
        self.this_class.class_name = self.classNameText
        try? moc.save()
    }
}

struct ClassView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let this_class = Class_CD(context: moc)
        this_class.class_name = "Example Class Name"
        
        let this_task = Task_CD(context: moc)
        this_task.text = "Example Task description"
        this_task.dueDate = "6/19"
        
        let this_task2 = Task_CD(context: moc)
        this_task2.text = "sdkgjsdj"
        this_task2.dueDate = "Asdkfjlj"
        
        this_class.addToTasks(this_task)
        this_class.addToTasks(this_task2)
        
        let example: SharedInt = SharedInt()
        
        return ClassView(this_class: this_class, background: Color("Light, numClasses: <#SharedInt#> Green"), tasks: [this_task, this_task2], numClasses: example)
    }
}

