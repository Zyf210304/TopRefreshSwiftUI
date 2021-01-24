//
//  ContentView.swift
//  TopRefresh
//
//  Created by 张亚飞 on 2021/1/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Home : View {
    
    @State var arrayData = ["Hello Data 1", "Hello Data 2", "Hello Data 3", "Hello Data 4", "Hello Data 5", "Hello Data 6"]
    @State var refresh = Refresh(started: false, released: false)
    
    var body: some View {
        
        VStack (spacing: 0){
            
            HStack {
                
                Text("Kavsoft")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.purple)
                    
                Spacer()
            }
            .padding()
            .background(Color.white.ignoresSafeArea(.all, edges: .top))
            
            
            Divider()
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                GeometryReader { reader -> AnyView in
                    
                    
                    DispatchQueue.main.async {
                        if refresh.startOffset == 0 {
                            refresh.startOffset = reader.frame(in: .global).minY
                        }
                        
                        refresh.offset = reader.frame(in: .global).minY
                        
                        if refresh.offset - refresh.startOffset > 80 && !refresh.started {
                            
                            refresh.started = true
                        }
                        
                        if refresh.startOffset == refresh.offset && refresh.started && !refresh.released {
                            
                            withAnimation(Animation.linear) {
                                refresh.released = true
                            }
                            updateData()
                        }
                        
                        if refresh.startOffset == refresh.offset && refresh.started && refresh.released && refresh.invalid {
                            
                            refresh.invalid = false
                            updateData()
                        }
                    }
                   
                    
                    return AnyView(Color.black.frame(width: 0, height: 0))
                }
                .frame(width: 0, height: 0)
                
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    
                    if refresh.started && refresh.released {
                        
                        ProgressView()
                            .offset(y : -35)
                    }
                    else {
                        
                        Image(systemName: "arrow.down")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(.gray)
                            .rotationEffect(.init(degrees: refresh.started ? 180 : 0))
                            .offset(y : -25)
                            .animation(.easeIn)
                    }
                    
                    VStack {
                        
                        ForEach(arrayData, id:\.self) { value in
                            
                            HStack {
                                
                                Text(value)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
                    }
                    .background(Color.white)
                    
                   
                }
                .offset(y : refresh.released ? 40 : -10)
            })
        }
        .background(Color.black.opacity(0.06).ignoresSafeArea())
    }
    
    
    func updateData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            withAnimation(Animation.linear) {
                
                if refresh.startOffset == refresh.offset {
                    
                    arrayData.append("Updated Data")
                    refresh.released = false
                    refresh.started = false
                }
                else {
                    
                    refresh.invalid = true
                }
                
            }
        }
    }
}


struct Refresh {
    var startOffset : CGFloat = 0
    var offset : CGFloat = 0
    var started : Bool
    var released : Bool
    var invalid : Bool = false
}
