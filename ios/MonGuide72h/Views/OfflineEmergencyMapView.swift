import SwiftUI
import MapKit
import CoreLocation

public struct OfflineEmergencyMapView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @ObservedObject var locManager = LocationManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedCategory: POICategory? = nil
    @State private var searchText: String = ""
    @State private var isShowingListMode: Bool = false
    @State private var selectedPOI: EmergencyPOI? = nil
    
    // Map Region - Central Luxembourg by default
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 49.6116, longitude: 6.1319),
        span: MKCoordinateSpan(latitudeDelta: 0.35, longitudeDelta: 0.35)
    )
    
    public init() {}
    
    private var filteredPOIs: [EmergencyPOI] {
        OfflinePOIRepository.shared.filterPoints(
            category: selectedCategory,
            searchQuery: searchText,
            userLocation: locManager.location
        )
    }
    
    public var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    // Filter bar and mode switch
                    topControlBar
                    
                    if isShowingListMode {
                        listView
                    } else {
                        mapView
                    }
                }
                
                // Selected POI Bottom Card (Only in map mode)
                if !isShowingListMode, let poi = selectedPOI {
                    poiDetailCard(poi)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                }
            }
            .navigationTitle(loc.tr("map_view_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.title3)
                    }
                }
            }
            .onAppear {
                locManager.startUpdating()
                centerOnUserIfAvailable()
            }
        }
    }
    
    // MARK: - TOP CONTROL BAR
    
    private var topControlBar: some View {
        VStack(spacing: 8) {
            // Search Field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField(loc.tr("map_search_placeholder"), text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Toggle List vs Map
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isShowingListMode.toggle()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isShowingListMode ? "map.fill" : "list.bullet")
                        Text(isShowingListMode ? loc.tr("map_btn_map") : loc.tr("map_btn_list"))
                            .font(.caption.bold())
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal, 12)
            .padding(.top, 8)
            
            // Category Filter Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    categoryChip(title: loc.tr("map_chip_all"), icon: "square.grid.2x2.fill", category: nil, color: .blue)
                    categoryChip(title: loc.tr("map_chip_hospitals"), icon: "cross.case.fill", category: .hospital, color: .red)
                    categoryChip(title: loc.tr("map_chip_cgdis"), icon: "flame.fill", category: .cgdis, color: .orange)
                    categoryChip(title: loc.tr("map_chip_iodine"), icon: "pills.fill", category: .iodinePoint, color: .purple)
                    categoryChip(title: loc.tr("map_chip_shelter"), icon: "tent.fill", category: .shelter, color: .green)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 6)
            }
        }
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private func categoryChip(title: String, icon: String, category: POICategory?, color: Color) -> some View {
        let isSelected = selectedCategory == category
        return Button(action: {
            withAnimation {
                selectedCategory = category
                selectedPOI = nil
            }
        }) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                Text(title)
                    .font(.caption.bold())
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isSelected ? color : Color(.secondarySystemBackground))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
        }
    }
    
    // MARK: - MAP VIEW
    
    private var mapView: some View {
        ZStack(alignment: .topTrailing) {
            Map(coordinateRegion: $region, annotationItems: filteredPOIs) { poi in
                MapAnnotation(coordinate: poi.coordinate) {
                    POIAnnotationPin(poi: poi, isSelected: selectedPOI?.id == poi.id) {
                        withAnimation(.spring()) {
                            selectedPOI = poi
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            
            // Recenter Button
            Button(action: {
                centerOnUserIfAvailable()
            }) {
                Image(systemName: "location.fill")
                    .font(.headline)
                    .padding(10)
                    .background(Color(.systemBackground))
                    .foregroundColor(.blue)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding(.trailing, 16)
            .padding(.top, 16)
        }
    }
    
    // MARK: - LIST VIEW
    
    private var listView: some View {
        List {
            Section(header: Text("\(filteredPOIs.count) \(loc.tr("map_points_found"))")) {
                if filteredPOIs.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "location.slash")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text(loc.tr("map_no_results"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                } else {
                    ForEach(filteredPOIs) { poi in
                        POIListRow(poi: poi, userLocation: locManager.location)
                            .onTapGesture {
                                selectedPOI = poi
                                region.center = poi.coordinate
                                isShowingListMode = false
                            }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    // MARK: - POI DETAIL CARD (MAP OVERLAY)
    
    private func poiDetailCard(_ poi: EmergencyPOI) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                // Category Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(categoryColor(poi.category))
                        .frame(width: 44, height: 44)
                    Image(systemName: poi.category.icon)
                        .foregroundColor(.white)
                        .font(.title3)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(poi.name)
                        .font(.headline)
                        .lineLimit(2)
                    
                    HStack(spacing: 6) {
                        Text(poi.commune)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if let dist = poi.distanceFormatted(from: locManager.location) {
                            Text("• \(dist)")
                                .font(.caption.bold())
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        selectedPOI = nil
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.title3)
                }
            }
            
            // Address & Hours
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.secondary)
                        .font(.caption2)
                    Text("\(poi.address), \(poi.postalCode) \(poi.commune)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.green)
                        .font(.caption2)
                    Text(poi.openingHours)
                        .font(.caption.bold())
                        .foregroundColor(.primary)
                }
            }
            
            // Action Buttons
            HStack(spacing: 10) {
                if let phoneUrl = poi.cleanPhoneUrl, let phone = poi.phone {
                    Link(destination: phoneUrl) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text(phone)
                                .bold()
                        }
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                
                if let mapsUrl = poi.appleMapsDirectionsURL {
                    Link(destination: mapsUrl) {
                        HStack {
                            Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                            Text(loc.tr("map_btn_navigate"))
                                .bold()
                        }
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.18), radius: 10, x: 0, y: 4)
    }
    
    private func centerOnUserIfAvailable() {
        if let userLoc = locManager.location {
            withAnimation {
                region.center = userLoc.coordinate
                region.span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
            }
        }
    }
    
    private func categoryColor(_ cat: POICategory) -> Color {
        switch cat {
        case .hospital: return .red
        case .cgdis: return .orange
        case .iodinePoint: return .purple
        case .shelter: return .green
        }
    }
}

// MARK: - ANNOTATION PIN

private struct POIAnnotationPin: View {
    let poi: EmergencyPOI
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(pinColor)
                        .frame(width: isSelected ? 38 : 30, height: isSelected ? 38 : 30)
                        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
                    
                    Image(systemName: poi.category.icon)
                        .font(.system(size: isSelected ? 16 : 13, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(pinColor)
                    .frame(width: 8, height: 6)
                    .rotationEffect(Angle(degrees: 180))
                    .offset(y: -2)
            }
        }
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .animation(.spring(), value: isSelected)
    }
    
    private var pinColor: Color {
        switch poi.category {
        case .hospital: return .red
        case .cgdis: return .orange
        case .iodinePoint: return .purple
        case .shelter: return .green
        }
    }
}

// MARK: - LIST ROW

private struct POIListRow: View {
    let poi: EmergencyPOI
    let userLocation: CLLocation?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(rowColor)
                        .frame(width: 38, height: 38)
                    Image(systemName: poi.category.icon)
                        .foregroundColor(.white)
                        .font(.headline)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(poi.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 6) {
                        Text(poi.commune)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if let dist = poi.distanceFormatted(from: userLocation) {
                            Text("• \(dist)")
                                .font(.caption.bold())
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Spacer()
            }
            
            Text(poi.openingHours)
                .font(.caption.bold())
                .foregroundColor(.green)
            
            Text(poi.address)
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Services chips
            if !poi.emergencyServices.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(poi.emergencyServices, id: \.self) { s in
                            Text(s)
                                .font(.system(size: 10, weight: .medium))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(.secondarySystemBackground))
                                .foregroundColor(.secondary)
                                .cornerRadius(4)
                        }
                    }
                }
            }
            
            // Actions
            HStack(spacing: 8) {
                if let phoneUrl = poi.cleanPhoneUrl, let phone = poi.phone {
                    Link(destination: phoneUrl) {
                        HStack(spacing: 4) {
                            Image(systemName: "phone.fill")
                            Text(phone)
                        }
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.green.opacity(0.12))
                        .foregroundColor(.green)
                        .cornerRadius(6)
                    }
                }
                
                if let mapsUrl = poi.appleMapsDirectionsURL {
                    Link(destination: mapsUrl) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                            Text("Apple Maps")
                        }
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.12))
                        .foregroundColor(.blue)
                        .cornerRadius(6)
                    }
                }
            }
            .padding(.top, 2)
        }
        .padding(.vertical, 4)
    }
    
    private var rowColor: Color {
        switch poi.category {
        case .hospital: return .red
        case .cgdis: return .orange
        case .iodinePoint: return .purple
        case .shelter: return .green
        }
    }
}
