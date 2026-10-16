import SwiftUI

public struct OfflineGuideReaderView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @State private var searchText: String = ""
    
    public init() {}
    
    private var chapters: [OfficialGuideChapter] {
        OfflineGuideRepository.shared.getChapters(for: loc.currentLanguage)
    }
    
    public var body: some View {
        List {
            // Offline Status Banner
            Section {
                HStack(spacing: 12) {
                    Image(systemName: "wifi.slash")
                        .font(.title2)
                        .foregroundColor(.green)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(loc.tr("offline_ready_title"))
                            .font(.headline)
                        Text(loc.tr("offline_ready_sub"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            
            // 4 Chapters from the official guide
            ForEach(chapters) { chapter in
                Section(header: Label(chapter.titleKey, systemImage: chapter.icon)) {
                    Text(chapter.subtitleKey)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ForEach(chapter.sections) { sec in
                        NavigationLink(destination: GuideSectionDetailView(section: sec)) {
                            HStack(spacing: 12) {
                                Image(systemName: sec.icon)
                                    .font(.title3)
                                    .foregroundColor(.red)
                                    .frame(width: 28)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(sec.titleKey)
                                        .font(.subheadline.bold())
                                    if let sub = sec.subtitleKey {
                                        Text(sub)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(loc.tr("offline_guide_title"))
    }
}

public struct GuideSectionDetailView: View {
    let section: OfficialGuideSection
    @ObservedObject var loc = LocalizationManager.shared
    
    private var sectionNarrationText: String {
        var parts: [String] = []
        parts.append(section.titleKey)
        if let sub = section.subtitleKey {
            parts.append(sub)
        }
        if let alert = section.alertNotice {
            parts.append("Aviso importante: \(alert)")
        }
        for p in section.paragraphs {
            parts.append(p)
        }
        if !section.bulletPoints.isEmpty {
            parts.append(loc.tr("official_actions_title"))
            for bp in section.bulletPoints {
                parts.append(bp)
            }
        }
        return parts.joined(separator: ". ")
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                // Header
                HStack(spacing: 12) {
                    Image(systemName: section.icon)
                        .font(.system(size: 32))
                        .foregroundColor(.red)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(section.titleKey)
                            .font(.title3.bold())
                        if let sub = section.subtitleKey {
                            Text(sub)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.bottom, 4)
                
                // Voice Guide Bar (for spoken accessibility and offline listening)
                VoiceGuideBar(
                    title: section.titleKey,
                    textToSpeak: sectionNarrationText
                )
                
                // Critical Alert Callout if exists
                if let alert = section.alertNotice {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                        Text(alert)
                            .font(.subheadline.bold())
                            .foregroundColor(.red)
                    }
                    .padding()
                    .background(Color.red.opacity(0.12))
                    .cornerRadius(10)
                }
                
                // Paragraphs
                ForEach(section.paragraphs, id: \.self) { p in
                    Text(p)
                        .font(.body)
                        .lineSpacing(5)
                }
                
                // Bullet points
                if !section.bulletPoints.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(loc.tr("official_actions_title"))
                            .font(.headline)
                            .padding(.top, 4)
                        
                        ForEach(section.bulletPoints, id: \.self) { bp in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.subheadline)
                                    .padding(.top, 2)
                                Text(bp)
                                    .font(.subheadline)
                                    .lineSpacing(3)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                }
                
                // Offline Reference Badge
                HStack {
                    Image(systemName: "checkmark.icloud.fill")
                        .foregroundColor(.green)
                    Text(loc.tr("offline_local_badge"))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                    if let web = section.referenceWebsite {
                        Text(web)
                            .font(.caption2.bold())
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            VoiceGuideManager.shared.stop()
        }
    }
}
