import SwiftUI

// MARK: - 資料模型
struct TransactionItem: Identifiable {
    let id = UUID()
    let iconName: String
    let iconColor: Color
    let title: String
    let amount: Int
}

struct DailyExpenseSection: Identifiable {
    let id = UUID()
    let dateText: String
    let totalText: String
    let items: [TransactionItem]
}

// MARK: - 主畫面
struct ContentView: View {
    @State private var currentTab: Int = 0
    
    // 假資料
    let sections: [DailyExpenseSection] = [
        DailyExpenseSection(
            dateText: "2026/10/06 星期二",
            totalText: "$-50",
            items: [
                TransactionItem(iconName: "cup.and.saucer.fill", iconColor: .pink, title: "芝士奶蓋春烏龍 x 1 = 50", amount: -50)
            ]
        ),
        DailyExpenseSection(
            dateText: "2026/10/05 星期一",
            totalText: "$-75",
            items: [
                TransactionItem(iconName: "takeoutbag.and.cup.and.straw.fill", iconColor: .pink, title: "瑞穗巧克力牛奶 400ml x 1 = 42...", amount: -75)
            ]
        ),
        DailyExpenseSection(
            dateText: "2026/10/03 星期六",
            totalText: "$-446",
            items: [
                TransactionItem(iconName: "takeoutbag.and.cup.and.straw.fill", iconColor: .pink, title: "★御選肉鬆飯糰 x 1 = 28 (A)*麥...", amount: -56),
                TransactionItem(iconName: "fork.knife", iconColor: .pink, title: "01-大力原味鍋 x 1 = 170 25-...", amount: -390)
            ]
        )
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 背景底色
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. 頂部導覽列
                topNavigationBar
                
                // 2. 可滾動內容區
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 月度收支概況
                        monthlySummaryView
                        
                        // 中央滑動圖表區 (TabView)
                        chartCarouselView
                        
                        // 下方明細清單
                        expenseListView
                    }
                    .padding(.bottom, 80) // 預留懸浮按鈕空間
                }
            }
            
            // 3. 懸浮加號按鈕 (FAB)
            floatingAddButton
                .padding(.bottom, 20)
        }
    }
}

// MARK: - 子元件
private extension ContentView {
    
    // 頂部導覽列
    var topNavigationBar: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Button(action: {}) {
                HStack(spacing: 4) {
                    Text("2026年 10月")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.black)
                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {}) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .offset(x: 2, y: -2)
                    }
                }
                
                Button(action: {}) {
                    Image(systemName: "calendar")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    // 月收支數字列
    var monthlySummaryView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text("月支出")
                        .font(.system(size: 14, weight: .bold))
                    Image(systemName: "play.fill")
                        .font(.system(size: 8))
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.yellow.opacity(0.4))
                .cornerRadius(4)
                
                Text("$1,114")
                    .font(.system(size: 22, weight: .black))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Text("月收入")
                        .font(.system(size: 14, weight: .bold))
                    Image(systemName: "play.fill")
                        .font(.system(size: 8))
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.cyan.opacity(0.3))
                .cornerRadius(4)
                
                Text("$0")
                    .font(.system(size: 22, weight: .black))
            }
        }
        .padding(.horizontal, 20)
    }
    
    // 中央輪播儀表板
    var chartCarouselView: some View {
        TabView(selection: $currentTab) {
            // 第 1 頁：甜甜圈結餘圖表
            balanceDonutView
                .tag(0)
            
            // 第 2 頁：預算進度球
            budgetLiquidView
                .tag(1)
        }
        .frame(height: 240)
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
    
    // 甜甜圈圖
    var balanceDonutView: some View {
        ZStack {
            // 甜甜圈厚邊框與黃底
            Circle()
                .stroke(Color.black, lineWidth: 2)
                .background(Circle().fill(Color(red: 254/255, green: 206/255, blue: 83/255)))
                .frame(width: 200, height: 200)
            
            Circle()
                .fill(Color.white)
                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                .frame(width: 120, height: 120)
            
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Text("月結餘")
                        .font(.system(size: 13, weight: .bold))
                    Image(systemName: "eye")
                        .font(.system(size: 12))
                }
                Text("$-1,114")
                    .font(.system(size: 18, weight: .heavy))
            }
        }
    }
    
    // 預算圖
    var budgetLiquidView: some View {
        ZStack {
            Circle()
                .stroke(Color.black, lineWidth: 2)
                .background(Circle().fill(Color(white: 0.95)))
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(
                    // 底部波浪/色塊
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color(red: 255/255, green: 110/255, blue: 110/255))
                            .frame(height: 90)
                    }
                    .clipShape(Circle())
                )
            
            VStack(spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "lock")
                        .font(.system(size: 11))
                    Text("當月剩餘預算")
                        .font(.system(size: 12, weight: .bold))
                }
                
                HStack(spacing: 2) {
                    Text("$5,000")
                        .font(.system(size: 14, weight: .bold))
                    Text("/$10,000")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "suit.diamond.fill")
                        .font(.system(size: 10))
                    Text("解鎖預算功能")
                        .font(.system(size: 11, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.black)
                .cornerRadius(12)
            }
        }
    }
    
    // 列表區塊
    var expenseListView: some View {
        VStack(spacing: 14) {
            ForEach(sections) { section in
                VStack(spacing: 0) {
                    // 卡片 Header
                    HStack {
                        Text(section.dateText)
                            .font(.system(size: 15, weight: .bold))
                        Spacer()
                        Text(section.totalText)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(red: 236/255, green: 194/255, blue: 109/255))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    
                    Divider()
                        .background(Color.black)
                    
                    // 卡片內容 Row
                    ForEach(section.items) { item in
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(item.iconColor.opacity(0.85))
                                    .frame(width: 32, height: 32)
                                Image(systemName: item.iconName)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .overlay(Circle().stroke(Color.black, lineWidth: 1.5))
                            
                            Text(item.title)
                                .font(.system(size: 14, weight: .medium))
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text("$\(item.amount)")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 2)
                )
                .padding(.horizontal, 16)
            }
        }
    }
    
    // 底部懸浮按鈕
    var floatingAddButton: some View {
        Button(action: {}) {
            Image(systemName: "plus")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 58, height: 58)
                .background(Color(red: 247/255, green: 114/255, blue: 118/255))
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.black, lineWidth: 2.5)
                )
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
        }
    }
}

#Preview {
    ContentView()
}
