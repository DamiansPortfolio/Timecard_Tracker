
import SwiftUI

struct TimecardByDayView: View {
    let dailyTimecard: TimecardByDay
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(dailyTimecard.day)
                        .font(.headline)
                    Text(dailyTimecard.dateString)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    if let hours = dailyTimecard.hours {
                        Text("\(hours, specifier: "%.1f") hrs")
                            .font(.subheadline)
                    }
                    
                    if let status = dailyTimecard.status {
                        StatusBadge(status: status)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
}
