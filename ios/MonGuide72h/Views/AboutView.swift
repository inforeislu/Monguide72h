import SwiftUI

public struct AboutView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header App & Logo InfoReis
                    VStack(spacing: 12) {
                        Image("InfoReisLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 70)
                            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                        
                        Text(loc.tr("app_title"))
                            .font(.title2.bold())
                            .multilineTextAlignment(.center)
                        
                        Text(loc.tr("app_subtitle"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text(loc.tr("version_label"))
                            .font(.caption.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.12))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }
                    .padding(.top, 10)
                    
                    // Official Mission Disclaimer & Government Logo
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(spacing: 8) {
                            Image(systemName: "building.columns.fill")
                                .foregroundColor(.orange)
                            Text(loc.tr("mission_title"))
                                .font(.headline)
                        }
                        
                        // Official Luxembourg Government Badge
                        HStack {
                            Image("GovLuxLogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 34)
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 1)
                        
                        Text(loc.tr("mission_desc"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineSpacing(3)
                        
                        Link(destination: URL(string: "https://letzprepare.public.lu")!) {
                            HStack {
                                Text(loc.tr("access_web"))
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                            }
                            .font(.subheadline.bold())
                            .foregroundColor(.blue)
                        }
                        .padding(.top, 4)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // InfoReis Developer Card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "laptopcomputer.and.iphone")
                                .foregroundColor(.blue)
                                .font(.title3)
                            Text(loc.tr("dev_by"))
                                .font(.headline)
                        }
                        
                        Text(loc.tr("dev_desc"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Divider().padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                            Text(loc.tr("website_label"))
                                .font(.subheadline.bold())
                            Spacer()
                            Link("www.inforeis.uk", destination: URL(string: "https://www.inforeis.uk") ?? URL(string: "https://letzprepare.public.lu")!)
                                .font(.subheadline)
                        }
                        
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.blue)
                            Text(loc.tr("contact_label"))
                                .font(.subheadline.bold())
                            Spacer()
                            Text("info@inforeis.uk")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // Copyright
                    Text(loc.tr("copyright"))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                }
                .padding()
            }
            .navigationTitle(loc.tr("about_menu_title"))
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text(loc.tr("close_btn"))
                    .bold()
            })
        }
    }
}
