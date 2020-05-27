//
//  ClassGrid.swift
//  HomeworkPlanner
//
//  Created by Zane Bookbinder on 4/29/20.
//  Copyright © 2020 Zane Bookbinder. All rights reserved.
//

import CoreData
import SwiftUI

struct ClassGrid: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Class_CD.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Class_CD.createdAt, ascending: true)])
        var classes: FetchedResults<Class_CD>
            
    @ObservedObject var numClasses: SharedInt
        
    var onerow = [0,1,2,3,4,5]
    var colors: [Color] = [Color("Light Purple"),Color("Light Green"), Color("Light Blue"),Color("Light Yellow"), Color("Light Teal"), Color("Tan"), Color("Sky Blue"), Color("Light Pink"), Color("Salmon Pink"), Color("Turquiose")]
    
    var body: some View {
        if(onerow.contains(self.classes.count)){
            return AnyView(VStack{
                HStack(spacing: 10) {
                    ForEach(self.classes, id: \.self){ myclass in
                        ClassView(this_class: myclass, background: self.colors[self.classes.firstIndex(of: myclass) ?? 0], tasks: myclass.taskArray, numClasses: self.numClasses).environment(\.managedObjectContext, self.moc)
                    }
                }
            })
        } else {
            return AnyView(VStack{
                HStack(spacing: 10){
                    ForEach(0..<5, id: \.self) { num in
                        ClassView(this_class: self.classes[num], background: self.colors[num], tasks: self.classes[num].taskArray, numClasses: self.numClasses).environment(\.managedObjectContext, self.moc)
                    }
                }
                HStack(spacing: 10){
                    if(self.classes.count<11){
                        ForEach(5..<self.classes.count, id: \.self) { num in
                            ClassView(this_class: self.classes[num], background: self.colors[num], tasks: self.classes[num].taskArray, numClasses: self.numClasses).environment(\.managedObjectContext, self.moc)
                        }
                    } else{
                        ForEach(5..<10, id: \.self) { num in
                            ClassView(this_class: self.classes[num], background: self.colors[num], tasks: self.classes[num].taskArray, numClasses: self.numClasses).environment(\.managedObjectContext, self.moc)
                        }
                    }
                }
            })
        }
    }
}

//struct ClassGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassGrid(numClasses: 0)
//    }
//}
