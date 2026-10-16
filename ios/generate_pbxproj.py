import uuid
import os

def gen_id():
    return uuid.uuid4().hex[:24].upper()

files = [
    ('MonGuide72hApp.swift', 'MonGuide72h/MonGuide72hApp.swift', 'sourcecode.swift', 'sources'),
    ('Language.swift', 'MonGuide72h/Models/Language.swift', 'sourcecode.swift', 'sources'),
    ('Country.swift', 'MonGuide72h/Models/Country.swift', 'sourcecode.swift', 'sources'),
    ('HouseholdMember.swift', 'MonGuide72h/Models/HouseholdMember.swift', 'sourcecode.swift', 'sources'),
    ('EmergencyPlan.swift', 'MonGuide72h/Models/EmergencyPlan.swift', 'sourcecode.swift', 'sources'),
    ('SirenType.swift', 'MonGuide72h/Models/SirenType.swift', 'sourcecode.swift', 'sources'),
    ('KitCalculatorViewModel.swift', 'MonGuide72h/ViewModels/KitCalculatorViewModel.swift', 'sourcecode.swift', 'sources'),
    ('EmergencyPlanViewModel.swift', 'MonGuide72h/ViewModels/EmergencyPlanViewModel.swift', 'sourcecode.swift', 'sources'),
    ('SirenAudioPlayer.swift', 'MonGuide72h/ViewModels/SirenAudioPlayer.swift', 'sourcecode.swift', 'sources'),
    ('TorchManager.swift', 'MonGuide72h/ViewModels/TorchManager.swift', 'sourcecode.swift', 'sources'),
    ('PDFExportManager.swift', 'MonGuide72h/ViewModels/PDFExportManager.swift', 'sourcecode.swift', 'sources'),
    ('ExpiryNotificationManager.swift', 'MonGuide72h/ViewModels/ExpiryNotificationManager.swift', 'sourcecode.swift', 'sources'),
    ('MainTabView.swift', 'MonGuide72h/Views/MainTabView.swift', 'sourcecode.swift', 'sources'),
    ('KitCalculatorView.swift', 'MonGuide72h/Views/KitCalculatorView.swift', 'sourcecode.swift', 'sources'),
    ('EvacuationBagView.swift', 'MonGuide72h/Views/EvacuationBagView.swift', 'sourcecode.swift', 'sources'),
    ('EmergencyPlanView.swift', 'MonGuide72h/Views/EmergencyPlanView.swift', 'sourcecode.swift', 'sources'),
    ('SirensView.swift', 'MonGuide72h/Views/SirensView.swift', 'sourcecode.swift', 'sources'),
    ('RisksGuideView.swift', 'MonGuide72h/Views/RisksGuideView.swift', 'sourcecode.swift', 'sources'),
    ('ScenarioTimelineView.swift', 'MonGuide72h/Views/ScenarioTimelineView.swift', 'sourcecode.swift', 'sources'),
    ('OfflineGuideRepository.swift', 'MonGuide72h/Models/OfflineGuideRepository.swift', 'sourcecode.swift', 'sources'),
    ('OfflineGuideReaderView.swift', 'MonGuide72h/Views/OfflineGuideReaderView.swift', 'sourcecode.swift', 'sources'),
    ('GuidesHubView.swift', 'MonGuide72h/Views/GuidesHubView.swift', 'sourcecode.swift', 'sources'),
    ('ActPlansGuideView.swift', 'MonGuide72h/Views/ActPlansGuideView.swift', 'sourcecode.swift', 'sources'),
    ('AboutView.swift', 'MonGuide72h/Views/AboutView.swift', 'sourcecode.swift', 'sources'),
    ('ExpiryTrackerView.swift', 'MonGuide72h/Views/ExpiryTrackerView.swift', 'sourcecode.swift', 'sources'),
    ('CrisisTriageView.swift', 'MonGuide72h/Views/CrisisTriageView.swift', 'sourcecode.swift', 'sources'),
    ('SplashScreenView.swift', 'MonGuide72h/Views/SplashScreenView.swift', 'sourcecode.swift', 'sources'),
    ('EmergencySOSAlarmView.swift', 'MonGuide72h/Views/EmergencySOSAlarmView.swift', 'sourcecode.swift', 'sources'),
    ('LocationManager.swift', 'MonGuide72h/ViewModels/LocationManager.swift', 'sourcecode.swift', 'sources'),
    ('SOSAlarmManager.swift', 'MonGuide72h/ViewModels/SOSAlarmManager.swift', 'sourcecode.swift', 'sources'),
    ('VoiceGuideManager.swift', 'MonGuide72h/ViewModels/VoiceGuideManager.swift', 'sourcecode.swift', 'sources'),
    ('VoiceGuideBar.swift', 'MonGuide72h/Views/VoiceGuideBar.swift', 'sourcecode.swift', 'sources'),
    ('FamilyDrillViewModel.swift', 'MonGuide72h/ViewModels/FamilyDrillViewModel.swift', 'sourcecode.swift', 'sources'),
    ('FamilyDrillView.swift', 'MonGuide72h/Views/FamilyDrillView.swift', 'sourcecode.swift', 'sources'),
    ('TacticalModeManager.swift', 'MonGuide72h/ViewModels/TacticalModeManager.swift', 'sourcecode.swift', 'sources'),
    ('TacticalNightVisionView.swift', 'MonGuide72h/Views/TacticalNightVisionView.swift', 'sourcecode.swift', 'sources'),
    ('WidgetDataManager.swift', 'MonGuide72h/ViewModels/WidgetDataManager.swift', 'sourcecode.swift', 'sources'),
    ('WidgetComponents.swift', 'MonGuide72h/Views/WidgetComponents.swift', 'sourcecode.swift', 'sources'),
    ('WidgetShowcaseView.swift', 'MonGuide72h/Views/WidgetShowcaseView.swift', 'sourcecode.swift', 'sources'),
    ('LocalizationManager.swift', 'MonGuide72h/Localization/LocalizationManager.swift', 'sourcecode.swift', 'sources'),
    ('WatchConnectivityManager.swift', 'MonGuide72h/ViewModels/WatchConnectivityManager.swift', 'sourcecode.swift', 'sources'),
    ('Assets.xcassets', 'MonGuide72h/Assets.xcassets', 'folder.assetcatalog', 'resources'),
    ('PrivacyInfo.xcprivacy', 'MonGuide72h/PrivacyInfo.xcprivacy', 'text.xml', 'resources'),
('EmergencyPOI.swift', 'MonGuide72h/Models/EmergencyPOI.swift', 'sourcecode.swift', 'sources'),
    ('OfflinePOIRepository.swift', 'MonGuide72h/Models/OfflinePOIRepository.swift', 'sourcecode.swift', 'sources'),
    ('OfflineEmergencyMapView.swift', 'MonGuide72h/Views/OfflineEmergencyMapView.swift', 'sourcecode.swift', 'sources'),
('PlanSharingManager.swift', 'MonGuide72h/ViewModels/PlanSharingManager.swift', 'sourcecode.swift', 'sources'),
    ('QRCodeScannerView.swift', 'MonGuide72h/Views/QRCodeScannerView.swift', 'sourcecode.swift', 'sources'),
    ('FamilyPlanSharingView.swift', 'MonGuide72h/Views/FamilyPlanSharingView.swift', 'sourcecode.swift', 'sources'),
('EmergencyRadioStation.swift', 'MonGuide72h/Models/EmergencyRadioStation.swift', 'sourcecode.swift', 'sources'),
    ('EmergencyRadioGuideView.swift', 'MonGuide72h/Views/EmergencyRadioGuideView.swift', 'sourcecode.swift', 'sources'),
('MedicalICECard.swift', 'MonGuide72h/Models/MedicalICECard.swift', 'sourcecode.swift', 'sources'),
    ('MedicalICECardManager.swift', 'MonGuide72h/ViewModels/MedicalICECardManager.swift', 'sourcecode.swift', 'sources'),
    ('MedicalICEWallpaperView.swift', 'MonGuide72h/Views/MedicalICEWallpaperView.swift', 'sourcecode.swift', 'sources'),
    ('RescueSignalingView.swift', 'MonGuide72h/Views/RescueSignalingView.swift', 'sourcecode.swift', 'sources'),
]

file_entries = []
build_files = []
sources_entries = []
resources_entries = []
group_children = []

for fname, fpath, ftype, phase in files:
    fid = gen_id()
    bid = gen_id()
    file_entries.append(f'\t\t{fid} /* {fname} */ = {{isa = PBXFileReference; lastKnownFileType = {ftype}; path = "{fpath}"; sourceTree = "<group>"; }};')
    build_files.append(f'\t\t{bid} /* {fname} in {phase.capitalize()} */ = {{isa = PBXBuildFile; fileRef = {fid} /* {fname} */; }};')
    if phase == 'sources':
        sources_entries.append(f'\t\t\t\t{bid} /* {fname} in Sources */,')
    elif phase == 'resources':
        resources_entries.append(f'\t\t\t\t{bid} /* {fname} in Resources */,')
    group_children.append(f'\t\t\t\t{fid} /* {fname} */,')

proj_id = gen_id()
target_id = '3D029350980545118DC5D8FC'
config_list_target = gen_id()
config_list_proj = gen_id()
sources_build_phase = gen_id()
frameworks_build_phase = gen_id()
resources_build_phase = gen_id()
main_group_id = gen_id()
debug_proj_config = gen_id()
release_proj_config = gen_id()
debug_target_config = gen_id()
release_target_config = gen_id()

content = f'''// !$*UTF8*$!
{{
\tarchiveVersion = 1;
\tclasses = {{
\t}};
\tobjectVersion = 56;
\tobjects = {{

/* Begin PBXBuildFile section */
{chr(10).join(build_files)}
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
{chr(10).join(file_entries)}
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
\t\t{frameworks_build_phase} /* Frameworks */ = {{
\t\t\tisa = PBXFrameworksBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
\t\t{main_group_id} = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{chr(10).join(group_children)}
\t\t\t);
\t\t\tsourceTree = "<group>";
\t\t}};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
\t\t{target_id} /* MonGuide72h */ = {{
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = {config_list_target} /* Build configuration list for PBXNativeTarget "MonGuide72h" */;
\t\t\tbuildPhases = (
\t\t\t\t{sources_build_phase} /* Sources */,
\t\t\t\t{frameworks_build_phase} /* Frameworks */,
\t\t\t\t{resources_build_phase} /* Resources */,
\t\t\t);
\t\t\tbuildRules = (
\t\t\t);
\t\t\tdependencies = (
\t\t\t);
\t\t\tname = MonGuide72h;
\t\t\tproductName = MonGuide72h;
\t\t\tproductType = "com.apple.product-type.application";
\t\t}};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
\t\t{proj_id} /* Project object */ = {{
\t\t\tisa = PBXProject;
\t\t\tattributes = {{
\t\t\t\tBuildIndependentTargetsInParallel = 1;
\t\t\t\tLastUpgradeCheck = 2700;
\t\t\t\tTargetAttributes = {{
\t\t\t\t\t{target_id} = {{
\t\t\t\t\t\tCreatedOnToolsVersion = 27.0;
\t\t\t\t\t\tDevelopmentTeam = QLAXP76RLT;
\t\t\t\t\t\tProvisioningStyle = Automatic;
\t\t\t\t\t}};
\t\t\t\t}};
\t\t\t}};
\t\t\tbuildConfigurationList = {config_list_proj} /* Build configuration list for PBXProject "MonGuide72h" */;
\t\t\tcompatibilityVersion = "Xcode 14.0";
\t\t\tdevelopmentRegion = en;
\t\t\thasScannedForEncodings = 0;
\t\t\tknownRegions = (
\t\t\t\ten,
\t\t\t\tBase,
\t\t\t);
\t\t\tmainGroup = {main_group_id};
\t\t\tproductRefGroup = {main_group_id};
\t\t\tprojectDirPath = "";
\t\t\tprojectRoot = "";
\t\t\ttargets = (
\t\t\t\t{target_id} /* MonGuide72h */,
\t\t\t);
\t\t}};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
\t\t{resources_build_phase} /* Resources */ = {{
\t\t\tisa = PBXResourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
{chr(10).join(resources_entries)}
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
\t\t{sources_build_phase} /* Sources */ = {{
\t\t\tisa = PBXSourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
{chr(10).join(sources_entries)}
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
\t\t{debug_proj_config} /* Debug */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ANALYZER_NONNULL = YES;
\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;
\t\t\t\tENABLE_TESTABILITY = YES;
\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;
\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;
\t\t\t\tGCC_PREPROCESSOR_DEFINITIONS = (
\t\t\t\t\t"DEBUG=1",
\t\t\t\t\t"$(inherited)",
\t\t\t\t);
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 16.0;
\t\t\t\tMTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
\t\t\t\tONLY_ACTIVE_ARCH = YES;
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Onone";
\t\t\t}};
\t\t\tname = Debug;
\t\t}};
\t\t{release_proj_config} /* Release */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ANALYZER_NONNULL = YES;
\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;
\t\t\t\tENABLE_NS_ASSERTIONS = NO;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 16.0;
\t\t\t\tMTL_ENABLE_DEBUG_INFO = NO;
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-O";
\t\t\t\tVALIDATE_PRODUCT = YES;
\t\t\t}};
\t\t\tname = Release;
\t\t}};
\t\t{debug_target_config} /* Debug */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 3;
\t\t\t\tDEVELOPMENT_TEAM = QLAXP76RLT;
\t\t\t\tGENERATE_INFOPLIST_FILE = NO;
\t\t\t\tINFOPLIST_FILE = MonGuide72h/Info.plist;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$(inherited)",
\t\t\t\t\t"@executable_path/Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.2.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.inforeis.MonGuide72h;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t}};
\t\t\tname = Debug;
\t\t}};
\t\t{release_target_config} /* Release */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 3;
\t\t\t\tDEVELOPMENT_TEAM = QLAXP76RLT;
\t\t\t\tGENERATE_INFOPLIST_FILE = NO;
\t\t\t\tINFOPLIST_FILE = MonGuide72h/Info.plist;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$(inherited)",
\t\t\t\t\t"@executable_path/Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.2.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.inforeis.MonGuide72h;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t}};
\t\t\tname = Release;
\t\t}};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
\t\t{config_list_proj} /* Build configuration list for PBXProject "MonGuide72h" */ = {{
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t{debug_proj_config} /* Debug */,
\t\t\t\t{release_proj_config} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t}};
\t\t{config_list_target} /* Build configuration list for PBXNativeTarget "MonGuide72h" */ = {{
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t{debug_target_config} /* Debug */,
\t\t\t\t{release_target_config} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t}};
/* End XCConfigurationList section */

\t}};
\trootObject = {proj_id} /* Project object */;
}}
'''

output_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'MonGuide72h.xcodeproj', 'project.pbxproj')
with open(output_path, 'w') as f:
    f.write(content)

print(f'Generated project.pbxproj successfully at {output_path}')
