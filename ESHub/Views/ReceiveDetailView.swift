//
//  ReceiveDetailView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/24.
//

import SwiftUI

struct ReceiveDetailView: View {
    let row: [String]
    var body: some View {
        GeometryReader { geometry in
            let titletWidth = geometry.size.width / 5
            let requestWidth = geometry.size.width / 3.5
            let titles = row[11].components(separatedBy: ", ")
            let times = row[12].components(separatedBy: ", ")
            let sounds = row[13].components(separatedBy: ", ")
            let lightings = row[14].components(separatedBy: ", ")
            
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    Text("横幅は \(geometry.size.width, specifier: "%.0f") ポイント")
                    
                    Group {
                        Text("提出日時")
                            .font(.title3)
                            .padding(.vertical, 5)
                        Text(row[0])
                    }
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Group {
                        Text("バンド名")
                            .font(.title3)
                            .padding(.vertical, 5)
                        Text(row[2])
                            .foregroundColor(Color("primaryButtonColor"))
                    }
                    
                    Spacer()
                        .frame(height: 40)
                    
                    Group {
                        HStack {
                            Text("曲名")
                                .frame(width: titletWidth, alignment: .leading)
                            Text("時間")
                                .frame(width: 50, alignment: .leading)
                            Text("音響要望")
                                .frame(width: requestWidth, alignment: .leading)
                            Text("照明要望")
                                .frame(width: requestWidth, alignment: .leading)
                        }
                        .padding(.vertical, 5)
                        
                        ForEach(0..<titles.count, id: \.self) { index in
                            HStack {
                                Text(titles[index])
                                    .frame(width: titletWidth, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                if times[index] != "0:00" {
                                    Text(times[index])
                                        .frame(width: 50, alignment: .leading)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                
                                Text(index < sounds.count ? sounds[index] : "")
                                    .frame(width: requestWidth, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Text(index < lightings.count ? lightings[index] : "")
                                    .frame(width: requestWidth, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Group {
                        Text("バンドメンバー")
                            .font(.title3)
                            .padding(.vertical, 5)
                        
                        if !row[3].isEmpty {
                            HStack {
                                Text("Vo. :")
                                    .frame(width: 50, alignment: .leading)
                                Text(row[3])
                            }
                            .padding(.horizontal)
                        }
                        if !row[4].isEmpty {
                            HStack {
                                Text("Gt1.:")
                                    .frame(width: 50, alignment: .leading)
                                Text(row[4])
                            }
                            .padding(.horizontal)
                        }
                        if !row[5].isEmpty {
                            HStack {
                                Text("Gt2.:")
                                    .frame(width: 50, alignment: .leading)
                                Text(row[5])
                            }
                            .padding(.horizontal)
                        }
                        if !row[6].isEmpty {
                            HStack {
                                Text("Ba. :")
                                    .frame(width: 50, alignment: .leading)
                                Text(row[6])
                            }
                            .padding(.horizontal)
                        }
                        if !row[7].isEmpty {
                            HStack {
                                Text("Dr. :")
                                    .frame(width: 50, alignment: .leading)
                                Text(row[7])
                            }
                            .padding(.horizontal)
                        }
                        if !row[8].isEmpty {
                            HStack {
                                Text("Key.:")
                                    .frame(width: 50, alignment: .leading)
                                Text(row[8])
                            }
                            .padding(.horizontal)
                        }
                        
                        
                        Spacer()
                            .frame(height: 30)
                        
                        Text("SE")
                            .font(.title3)
                        Spacer()
                            .frame(height: 10)
                        Text(row[9])
                            .pickerStyle(.segmented)
                            .frame(width: 100)
                        
                        Spacer()
                            .frame(height: 30)
                        
                        if !row[10].isEmpty {
                            Text("その他")
                                .font(.title3)
                            Spacer()
                                .frame(height: 10)
                            Text(row[10])
                                .frame(width: 300)
                                .lineLimit(7)
                        }
                    }
                }
            }
            .navigationTitle("バンド詳細")
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    ReceiveDetailView(row: [
        "date",
        "liveName",
        "bandName",
        "vo",
        "gt1",
        "gt2",
        "ba",
        "dr",
        "key",
        "あり",
        "otherRequestotherRequestotherRequestotherRequestotherRequestotherRequestotherRequestotherRequestotherRequestotherRequestotherRequestotherRequestotherRequestotherRequestotherRequest",
        "title, a, aaaaaaaa, aaa, aaa, aaaaaaa, aaa",
        "time, 22:55, 13:00, 14:00, 15:00",
        "sound",
        "lighting"
    ])
}
