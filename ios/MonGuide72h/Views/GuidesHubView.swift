import SwiftUI

/// Unified Hub for Risks, Sirens, Offline Book, Agir Plans, and Scenarios
public struct GuidesHubView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @State private var showingAbout = false
    @State private var showingTriageSheet = false
    @State private var showingDrillSheet = false
    @State private var showingWidgetSheet = false
    @State private var showingMapSheet = false
    @State private var showingICESheet = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            List {
                // Section 0: Emergency Crisis Triage & Drills
                Section(header: Text(loc.tr("hub_assist_title"))) {
                    // Offline Critical Infrastructure & Map
                    Button(action: {
                        showingMapSheet = true
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue)
                                    .frame(width: 42, height: 42)
                                Image(systemName: "map.fill")
                                    .foregroundColor(.white)
                                    .font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(loc.tr("hub_map_title"))
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(loc.tr("hub_map_tag"))
                                        .font(.system(size: 9, weight: .black))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                }
                                Text(loc.tr("hub_map_sub"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    // Triage
                    Button(action: {
                        showingTriageSheet = true
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red)
                                    .frame(width: 42, height: 42)
                                Image(systemName: "bolt.heart.fill")
                                    .foregroundColor(.white)
                                    .font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(loc.tr("hub_triage_title"))
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(loc.tr("hub_triage_tag"))
                                        .font(.system(size: 9, weight: .black))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                }
                                Text(loc.tr("hub_triage_sub"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    // Family Drill
                    Button(action: {
                        showingDrillSheet = true
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.green)
                                    .frame(width: 42, height: 42)
                                Image(systemName: "figure.walk.motion")
                                    .foregroundColor(.white)
                                    .font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(loc.tr("hub_drill_title"))
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(loc.tr("hub_drill_tag"))
                                        .font(.system(size: 9, weight: .black))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                }
                                Text(loc.tr("hub_drill_sub"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    // Widgets iOS & Lock Screen
                    Button(action: {
                        showingWidgetSheet = true
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(red: 0/255, green: 43/255, blue: 73/255))
                                    .frame(width: 42, height: 42)
                                Image(systemName: "apps.iphone")
                                    .foregroundColor(.white)
                                    .font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(loc.tr("hub_widgets_title"))
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(loc.tr("hub_widgets_tag"))
                                        .font(.system(size: 9, weight: .black))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                }
                                Text(loc.tr("hub_widgets_sub"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                                    // Fiche Médicale ICE & Wallpaper
                    Button(action: {
                        showingICESheet = true
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red.opacity(0.18))
                                    .frame(width: 42, height: 42)
                                Image(systemName: "cross.case.fill")
                                    .foregroundColor(.red)
                                    .font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(loc.tr("hub_ice_title"))
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(loc.tr("hub_ice_tag"))
                                        .font(.system(size: 9, weight: .black))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                }
                                Text(loc.tr("hub_ice_sub"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                // Section 1: Complete Official Book Offline
                Section(header: Text(loc.tr("hub_offline_title"))) {
                    NavigationLink(destination: OfflineGuideReaderView()) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue.opacity(0.18))
                                    .frame(width: 42, height: 42)
                                Image(systemName: "book.fill")
                                    .foregroundColor(.blue)
                                    .font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(loc.tr("offline_guide_title"))
                                        .font(.headline)
                                    Spacer()
                                    Text(loc.tr("offline_tag"))
                                        .font(.system(size: 9, weight: .black))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                }
                                Text(loc.tr("offline_guide_sub"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                // Section 2: Planos de Ação Oficiais ("Agir")
                Section(header: Text(loc.tr("hub_act_title"))) {
                    NavigationLink(destination: ActPlansGuideView()) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.orange.opacity(0.18))
                                    .frame(width: 42, height: 42)
                                Image(systemName: "bolt.shield.fill")
                                    .foregroundColor(.orange)
                                    .font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(loc.tr("act_plans_title"))
                                        .font(.headline)
                                    Spacer()
                                    Text(loc.tr("act_plans_tag"))
                                        .font(.system(size: 9, weight: .black))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.orange)
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                }
                                Text(loc.tr("act_plans_sub"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                // Section 3: Guias Práticos, Riscos e Sirenes
                Section(header: Text(loc.tr("hub_guides_title"))) {
                    NavigationLink(destination: ExpiryTrackerView()) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.orange.opacity(0.18))
                                    .frame(width: 38, height: 38)
                                Image(systemName: "calendar.badge.clock")
                                    .foregroundColor(.orange)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(loc.tr("tab_expiry"))
                                        .font(.headline)
                                    Spacer()
                                    Text(loc.tr("expiry_badge_active"))
                                        .font(.system(size: 9, weight: .black))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                }
                                Text(loc.tr("hub_expiry_desc"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    NavigationLink(destination: RisksGuideView()) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.yellow.opacity(0.2))
                                    .frame(width: 38, height: 38)
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(loc.tr("tab_risks"))
                                    .font(.headline)
                                Text(loc.tr("hub_risks_desc"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    NavigationLink(destination: SirensView()) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red.opacity(0.15))
                                    .frame(width: 38, height: 38)
                                Image(systemName: "speaker.wave.3.fill")
                                    .foregroundColor(.red)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(loc.tr("tab_sirens"))
                                    .font(.headline)
                                Text(loc.tr("hub_sirens_desc"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    NavigationLink(destination: EmergencyRadioGuideView()) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(red: 20/255, green: 40/255, blue: 70/255))
                                    .frame(width: 38, height: 38)
                                Image(systemName: "antenna.radiowaves.left.and.right")
                                    .foregroundColor(.yellow)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(loc.tr("hub_radio_title"))
                                        .font(.headline)
                                    Spacer()
                                    Text(loc.tr("hub_radio_tag"))
                                        .font(.system(size: 9, weight: .black))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color(red: 20/255, green: 40/255, blue: 70/255))
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                }
                                Text(loc.tr("hub_radio_sub"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    NavigationLink(destination: ScenarioTimelineView()) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.purple.opacity(0.15))
                                    .frame(width: 38, height: 38)
                                Image(systemName: "clock.arrow.circlepath")
                                    .foregroundColor(.purple)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(loc.tr("tab_timeline"))
                                    .font(.headline)
                                Text(loc.tr("hub_timeline_desc"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                // Section 4: Sobre a App & InfoReis
                Section(header: Text("InfoReis")) {
                    Button(action: {
                        showingAbout = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(loc.tr("about_menu_title"))
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(loc.tr("hub_version_subtitle"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        .padding(.vertical, 2)
                    }
                }
                
                // Section 5: Official Web Portals (when online)
                Section(header: Text(loc.tr("hub_sources_title"))) {
                    Link(destination: URL(string: "https://letzprepare.public.lu")!) {
                        HStack {
                            Image(systemName: "shield.lefthalf.filled")
                            Text("letzprepare.public.lu")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }
                    Link(destination: URL(string: "https://infocrise.gov.lu")!) {
                        HStack {
                            Image(systemName: "cross.case.fill")
                            Text("infocrise.gov.lu")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }
                    Link(destination: URL(string: "https://inondations.lu")!) {
                        HStack {
                            Image(systemName: "water.waves")
                            Text("inondations.lu")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }
                    Link(destination: URL(string: "https://112.public.lu")!) {
                        HStack {
                            Image(systemName: "phone.badge.waveform.fill")
                            Text("112.public.lu (CGDIS)")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(loc.tr("tab_hub"))
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
            .sheet(isPresented: $showingTriageSheet) {
                CrisisTriageView()
            }
            .sheet(isPresented: $showingDrillSheet) {
                FamilyDrillView()
            }
            .sheet(isPresented: $showingWidgetSheet) {
                WidgetShowcaseView()
            }
        }
    }

