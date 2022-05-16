//
//  StonksWidget.swift
//  StonksWidget
//
//  Created by Nikita Shvad on 16.05.2022.
//


import WidgetKit
import SwiftUI
import SharedResources

struct Provider: TimelineProvider {

    let networkManager = NetworkManager()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), data: .previewData, error: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        networkManager.getCryptoData { data in
            let entry = SimpleEntry(date: Date(), data: data ?? .error, error: data == nil)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        networkManager.getCryptoData { data in
            let quater = Calendar.current.date(byAdding: .minute, value: 15, to: Date())
            guard let quater = quater else { return }
            let timeline = Timeline(entries: [SimpleEntry(date: Date(), data: data ?? .error, error: data == nil)],
                                    policy: .after(quater))
            completion(timeline)
        }
    }
}

struct StonksWidgetEntryView : View {
    @Environment (\.widgetFamily) var family
    @Environment (\.colorScheme) var scheme

    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .unredacted()
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    header
                    Spacer()
                    pricing
                    Spacer()
                    volume
                    Spacer()
                }
            }
            .padding()
        }
    }

    var header: some View {
        Group {
            Text("Stonks")
                .bold()
                .font(family == .systemLarge ?
                    .system(size: 40): .title)
                .minimumScaleFactor(0.3)
            Text("Bitcoin")
                .font(family == .systemLarge ? .title : .headline)
                .padding(.top, family == .systemLarge ? -15 : 0)
        }
        .foregroundColor(Color("headingColor"))
    }

    var pricing: some View {
        Group {
            price
            difference
        }
    }

    var difference: some View {
        Text(entry.error ? "± ––––" :
                "\(entry.differenceMode == .up ? "+" : " ") \(String(format: "%.2f", entry.data.difference))")
        .bold()
        .foregroundColor(
            switch entry.differenceMode {
            case .up:
                Asset.Colors.upColor.color
            case .down:
                Asset.Colors.downColor.color
            default:
                Asset.Colors.errorColor.color
            }
        )
        .font(family == .systemSmall ? .footnote : .title2)
    }

    var price: some View {
        Text(entry.error ? "––––" :
                "\(String(format: "%.2f", entry.data.last_trade_price))")
        .bold()
        .font(family == .systemSmall ? .body : .system(size: CGFloat(family.rawValue * 25 + 12)))
        .minimumScaleFactor(0.5)
    }

    var volume: some View {
            Text(entry.error ? "––––" :
                    "VOLUME: \(String(format: "%.2f", entry.data.volume_24h))")
            .bold()
            .font(.footnote)
            .minimumScaleFactor(0.5)
            .foregroundColor(scheme == .dark ? .pink : .purple)
    }

@main
struct StonksWidget: Widget {
    let kind: String = "StonksWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StonksWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Stonks Widget")
        .description("Track Your Losses Accurately!")
    }
}

struct StonksWidget1_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StonksWidgetEntryView(entry: SimpleEntry(date: Date(), data: .previewData, error: false))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            StonksWidgetEntryView(entry: SimpleEntry(date: Date(), data: .previewData, error: false))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            StonksWidgetEntryView(entry: SimpleEntry(date: Date(), data: .previewData, error: false))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        .environment(\.colorScheme, .light)
        //.redacted(reason: .placeholder)
    }
}
}
